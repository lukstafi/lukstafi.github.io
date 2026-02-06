# Mind Maps — January 2025

## Apple Platforms (2025.01.13 – 2025.01.15)

### Apple's MLX (2025.01.13)

- Expression based like JAX — tracing → compute graph
  - But imperative and with stateful `Module` class
  - Pythonic: classes, generators
- Expr. transformations work on function objects: `grad`, `vmap`, `vjp`, `jvp`
- Specify device (cpu, gpu) at the expression / result array — actually, specify stream (since uniform memory)
- `array` vs. `vector`
- Good C interface
- Explicitly executed with `eval()` — implicitly executed by `print`, `memoryview`, `save`
  - Currently not compiled
- `compile()` optimizes graph e.g. by fusion — only for pure functions
  - Can compile the whole SGD update, support for capturing mutable state
- Formats: `.npy`, `.npz`, `.safetensors` (HuggingFace), `.gguf` (GGreganov)
- Distributed comp. via MPI: `all_sum`, `all_gather`, `send`, `recv` (an array)
- Exporting functions, can be imported cross-frontend
  - Only for fixed shapes, via example inputs
  - Exporting modules with or w/o params

### Apple Metal Quick Glance (2025.01.15)

- Can compile from commandline or at runtime a/synchronously from string: `newLibraryWithSource:options:completionHandler/error`
- Multilevel command buffer: blit/compute encoders
- Doesn't support `double` (?)

## Habits (2025.01.19)

- Atomic
  - Obvious — define trigger: definite time+location, or end of earlier habit
  - Attractive — community, temptation / ritual
  - Easy — reduce friction, prime the environment; downscale habit to two minutes; break down big ones into multiple; establish a <2min minimal satisfying version
  - Satisfying — immediate reward on completion; use habit tracker
- Modify habit — keep trigger and reward, replace routine
- Stepladder — small changes; Community; Important — dwell on priorities; Easy; Neurohack — behavior drives identity; Captivating rewards; Engrained — repetition

## Andrej Karpathy's Educational Resources (2025.01.20)

- GitHub repositories
- nn-zero-to-hero — introductory and experimental parts of the lectures
  - Lecture 1: micrograd — minimal NumPy NN framework
  - Lectures 2–5: makemore — bigram character-level LM
  - Lecture 8: nanoGPT — optimizes minGPT
- minGPT — the first GPT in PyTorch repo, purely educational
- nanoGPT
  - ng-video-lecture — follows the first, 2-hours lecture reproducing nanoGPT
  - build-nanogpt — follows latest, 4-hours lecture reproducing nanoGPT (improved lecture)
- minBPE — tokenizer for GPT
- char-rnn — character-level LM, old, in Lua Torch, vanilla Recurrent NN, GRU, LSTM
- llama2.c
  - train.py in PyTorch
  - run.c in FP32 pure C
  - runq.c in int8 quantized
- llm.c — very efficient C/CUDA, multi-GPU with ZeRO, optimized for pretraining GPT-2/3
  - Simple reference impls: train_gpt2.c in pure C, train_gpt2.cu in CUDA (this is the entry point to main impl.), train_gpt2.py in PyTorch

## llm.c Deep Dive (2025.01.21 – 2025.01.23)

### llm.c (2025.01.21)

- Uses cuBLAS, cuBLASLt in code for **matmul** forward and backward, manual kernel for backward bias term
- Manual kernels for: encoder forward and backward, layernorm forward and backward, softmax forward and (in-place) backward, Cross-Entropy forward fused with backward, AdamW (see slide 2024.11.20)
- Hyperparams for loading any GPT2 or GPT3
- Random init scheme from GPT2, init computed on the CPU
- Uses ZeRO for multi-GPU — uses MPI to distribute (to be continued)
- Two variants: with & w/o cuDNN, used for attention
- Uses stochastic rounding from FP32 to BF16
- Judiciously uses `size_t` to not overflow int
- Conserves memory by reusing buffers
- Manually manages memory (no per-tensor alloc/free)

### llm.c Distributed (2025.01.23)

- Sharded Data Parallel and FSDP not supported yet — only sharding optimizer states aka. ZeRO-1
- Dedicated CUDA stream for NCCL ops
- `llmc/zero.cuh` here, NCCL and MPI overview on future maps
- `multi_gpu_async_reduce_gradient`: reduce-scatter if ZeRO else all-reduce
- `gpt2_calculate_grad_norm`: reuses the activations buffer; without ZeRO, gradients already averaged across all GPUs, sums norms locally; with ZeRO, need to all-reduce-sum the norms
- Different network socket API causes some duplication between Windows and Linux

## CUDA Programming (2025.01.24 – 2025.01.25)

### CUDA Cooperative Groups (2025.01.24)

- API for thread subsets — first-class thread blocks
- `coalesced_group active = coalesced_threads()` — currently executing in a warp
  - `active.sync()` — no deadlock; protects from deadlocks wrt. `__syncthreads()`
- `group.sync()`, `group.thread_rank()` (no. of this thread in this group)
- `tiled_partition(group, size)` — if `size=32`, gives warps
  - `thread_block_tile<size>`, `tiled_partition<size>(group)`
- `thread_block_tile::...`: `shfl()`, `shfl_down()`, `shfl_up()`, `shfl_xor()`, `any()`, `all()`, `ballot()`, `match_any()`, `match_all()`
  - `#pragma unroll` since size is static — then, compiler can remove synchronizations (unsafe when done manually)
  - `__ffs`, `__popc`
- CUDA Warp-level primitives — 32-bit (int) masks pick threads of a warp
  - Synchronized data exchange: `__all_sync`, `__any_sync`, `__uni_sync`, `__ballot_sync`; `__shfl_sync`, `__shfl_up_sync`, `__shfl_down_sync`, `__shfl_xor_sync`; `__match_any_sync`, `__match_all_sync`
- Get `__activemask`; Sync with memory fence: `__syncwarp(mask=FULL_MASK)` (`0xffffffff`)

### CUDA Warp Functions: Vote, Match, Reduce, Shuffle (2025.01.25)

- Each calling thread must be in the mask, all masks must be the same
- Vote: `__all_sync`, `__any_sync` — the value is non-zero for all/any of the threads
- Match: `__match_any_sync` — returns the mask of threads with the same value as the calling thread; `__match_all_sync` — returns the given mask if all its threads have the same value, otherwise 0
- Vote: `__ballot_sync` — returns the mask of threads with non-zero value
- Reduce: `__reduce_add/min/max_sync` — reduces the int or unsigned values; `__reduce_and/or/xor_sync` — logical op reduces unsigned values
- Shuffle (shfl): exchange a variable between threads of a warp (faster than shared mem)
  - Unlike reduce functions, works with all numeric types, including `__half2` and `__nv_bfloat162`
  - `__shfl_sync` specifies source lane explicitly
  - `__shfl_up/down_sync` specify delta, source is lower/higher
  - `__shfl_xor_sync` bitwise XORs calling thread lane ID with the given lane mask (see: butterfly pattern)
  - Optional width (one of 2,4,8,16) subdivides operation into groups, with group-relative addressing
- Warp Matrix Functions leverage Tensor Cores for Matrix Multiply Add

## cuDNN (2025.01.26 – 2025.01.27)

### cuDNN: CUDA Deep Neural Network (2025.01.26)

- Frontend: C++ and Python APIs; Backend: C API
- C++ based on shared pointers
- All tensors have from 3 to 8 axes (with leading dims 1 if not needed)
- cuDNN graph performs inference: shapes for virtual/temp tensors, strides, precisions
  - Via `Graph::validate`
- Graph: fusion etc.
- Configurable defaults for: io, intermediate, and compute data type
- Autotuning — filtering: numerical, behavior, functional properties; policy-based selection; multiple heuristic-based execution plans
- Opt-in to use Tensor Core (in backend, not in frontend?)
- Multinode graphs do not support in-place operations
- Operations:
  - Matrix Mult. — matmul broadcasts even non-1 batch axes if needed
  - Convolution: forward, data grad, weight grad
  - Batch Normalization: forward, backprop, finalize stats
  - Layernorm: forward, backprop
  - Instancenorm: forward, backprop
  - Attention: forward, backprop — only for FP16, BF16, FP8
  - Pointwise: add, bias, scale, sub, mul, rsqrt, relu, elu, gelu, cmp_gt

### cuDNN Graphs (2025.01.27)

- Virtual tensors can be any type, but recommended FP32
- Mixed precision inputs via (pointwise) identity
- On Ada Lovelace, FP8 inputs trigger FP8 Tensor Cores
- Compute type FP32 / `CUDNN_DATA_FLOAT` (recommended for backward pass) and `CUDNN_DATA_FAST_FLOAT_FOR_FP8`
- Require exactly one batch axis
- Pre-compiled single operation engines: convolution and normalization ops
- Generic runtime fusion engines: only for pointwise ops → matmul or convolution (or none) → pointwise ops [→ reduction op]
- Specialized pre-compiled engines
  - Convolution-BatchNorm with ReLU activation
  - FP8 Fused Flash Attention max sequence length 512
  - Fused Attention with max seq length 512, forward and backward, e.g. similar to BERT and T5
    - Allows optional: scalar key scaling, padding or causal masks, softmax, dropout
- Specialized runtime fusion patterns
  - ResNet helpers: BatchNorm forward (with optional Add, ReLU, and (> 0) side output) and backward (with optional dReLU and side grad output for fwd's Add)
  - Support multi-GPU batches
  - Fused Flash Attention forward and backward, usable GPT and BERT like models
    - Configurable with many scaling, mask and dropout options

## Communication Libraries (2025.01.28 – 2025.01.30)

### MPI: Message Passing Interface and Collective Operations (2025.01.28)

- llm.c usage: 1 GPU = 1 process
  - Can initialize NCCL with: tcp, mpi, fs (fs: file system synchronization)
  - `MPI_Bcast` to initialize NCCL rank
  - `MPI_Allgather` to find the GPU's ordinal on a machine
- Send, Recv: point-to-point communication
- Broadcast: send from one to all
- Reduce: send from all, reduce on the fly into a value received by one
- All-Reduce: send from all, receive the same reduced value by all
- Gather: send from all, all values received by one node in a container
- All-Gather: send from all, every node receives all values in a container
- Scatter: send from a container on one node, a different value to every node
- Reduce-Scatter: pointwise reduces a vector and scatters the results
- All-to-all: each node has a container, from which it sends a different value to every node's receiving container
- Scan: each node receives a partially reduced value depending on its rank
- Vectorized versions of these, and dedicated versions where values are arrays

### NCCL: NVIDIA Collective Communications Library (2025.01.29)

- Deals with different GPU and interconnect types: PCIe, NVLINK, InfiniBand Verbs, IP sockets
- Single kernel handling both communication and computation
- Control: single-threaded, multi-threaded, multi-process including MPI
- Operations: All-Reduce, Broadcast, Reduce, All-Gather, Reduce-Scatter, Send, Recv
  - Root rank gets the result of Reduce
- A communicator has nodes (ranks) and issues collective operations, a communicator *object* is a node
- `ncclUniqueId` is the root rank, w/ it a given rank communicates. Can be a set `ncclUniqueIds`, all nodes must have the same set.
- Optionally can block, default async via stream queues — but enqueueing can block on other ranks to arrive first
- Using communicators concurrently can cause deadlocks. Even with separate streams, e.g. one uses too many blocks.
- Don't use streams while NCCL uses them
- A communicator object of a device can use host pointers, cannot use pointers of a peer device, to avoid programmer errors
- Cooperative Thread Arrays: threads of a warp?
- Group calls — dynamic scope `ncclGroupStart/End`
  - Must be used when single thread manages multiple devices
  - Aggregating operations might optimize communication
- To avoid internal copies: `ncclMemAlloc` & `ncclCommRegister`

### NCCL Usage in llm.c (2025.01.30)

- NCCL setup and helpers in `zero.cuh`
- `multi_gpu_async_reduce_gradient`: if not sharding then All-Reduce, if ZeRO-1 then Reduce-Scatter
- `gpt2_update`: All-Gather updated shards of params
- `gpt2_backward_and_reduce`: All-Reduce gradients per-layer in the last microbatch step, also All-Reduce `accumulated_mean_loss`
- `gpt2_calculate_grad_norm`: All-Reduce `grad_norm_squared`
- Main: Periodically compute and All-Reduce: validation loss, HellaSwag accuracy
- All-Reduce to compute memory stats

## Quick First Glance at Caten (2025.01.31)

- Lazy like tinygrad, but more control like OCANNL: explicitly forced, can be explicitly compiled
  - Unlike OCANNL compilation is optional
- API the same as NumPy/PyTorch? — cumbersome, verbose notation
- All graphs can be compiled with dynamic shapes (unlike tinygrad and current OCANNL)
- Compilation pipeline: shape inference, high-level → scheduler i.e. kernel demarcation and ordering → low-level → polyhedral IR → rendering kernels
- High-level (API) and low-level (AIR) graph interfaces, codegen, graph runner
- Focus on "NN inference runtime"
- Verdict: the code is too sprawling (e.g. too many files) to be worth digging into; better focus on tinygrad
  - But it's impressive, maybe I'll have some luck finding inspiration
- Interesting to look at: `source/api/`**`tensor`**`.lisp`, `source/codegen/`**`scheduler`**`.lisp`, `source/codegen/jit.lisp`, `source/codegen/`**`memory-planner`**`.lisp` (minimizes peak memory usage), `source/byoc/`**`metal`**`.lisp`, `external/llm/`**`layers`**`.lisp`
