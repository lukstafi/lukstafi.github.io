# Mind Maps — November 2024

## OCANNL Design (2024.11.07 – 2024.11.12)

### Factor Out of Backends (2024.11.07)

- Memory modes
- Is-in-context
- Updating context arrays
  - Based on `traced_arrays`
  - Before linking in backend

### Release 0.5 (2024.11.08)

- Factor out mem context ✓
  - Synchronize running routines
- Factor out copying prep ✓
  - Synchronize copying
- Remove syncing from the data-parallel algo
  - Debug data-parallel perf

### Program Search (2024.11.09)

- Symbolic optimization
  - Generic across backends
- Currently deterministic rewrite system
  - Nondeterministic rewrite system
    - Beam search and MCTS
- Needs backend-specific fitness

### Training Rig (2024.11.10)

- How best to connect the comps I have?
  - Thunderbolt 5 vs Ethernet
- iMac Mini
  - Cheap but less memory
- Razer Blade laptop?

### Managing Scarce Memory (2024.11.11)

- `evacuated` field
  - Actually, `evacuated_to : [Host | Stream Tn.t] option`
  - If node is evacuated, automatically schedule bringing it back when needed
  - Can evacuation be automated?
- `to_host ~evacuate:true`
- `device_to_device ~evacuate:true`?
  - Bringing back across multiple hops

### Data Movement Automation (2024.11.12)

- Default `from_host` to initialize hosted nodes on device
  - But the reverse for computational initialization e.g. random distr
- Similar to `evicted_to`
- Does not need an extra layer!
  - Explicit calls to backend work as currently
  - Automates backend calls
    - Available functions and/or exposed fields to disable or tune the automation

## Low-Precision Numbers and Quantization (2024.11.13)

### Low-Precision Numbers and Quantization (2024.11.13)

- bfloat16
  - Broad hardware support
  - Standardized?
  - Lobby for inclusion in Bigarray?
  - Low value per effort — but good stress test of design
- fp8
  - High-end hardware
  - Two fp8 types on H100
  - Blockwise quantization on Blackwell hardware
  - Missing compute precs — no design effort
- TF32: TensorFloat-32
  - Nvidia TensorCore
  - In fact it's 19 bits
- Quantized
  - Training vs inference
  - Simple discretization
  - Statistically quantizing trained models
  - Represent as multidim. precision
- Compute prec separated from mem store prec

## Strong Models Are Very Large (2024.11.14 – 2024.11.18)

### Strong Models Are Very Large (2024.11.14)

- Pipeline parallelism
  - Synchronous
  - Asynchronous
    - Multiple copies of grads or weights
    - Enforces: 1 worker = multiple streams
    - Ensure: possible to assign all resources to a stream while others suspended
- Networked devices
  - `Add_network` functor for backends
- Model parallelism (see 11.16)
  - Heterogeneous backends
    - Also: at-home networking Macs and Nvidia RTX
    - Should `Add_network` devices have an option "no network"? — No. Primary motivation

### Usability (2024.11.15)

- Runs the necessary fwd and bprop code
  - Tracking of what needs recomputing
  - Invokes `%op` if needed
  - Requiring module `Backend` in scope
- Extension layer `%run`?
  - Not needed for auto memory transfers
- Documentation
  - Consider `.mld` and/or `mdx`
- Install printers for `Tnode.t` and `Tensor.t`
- Saving/restoring
  - Full model graph saving
    - W/o pickling aka. marshalling
  - Granular snapshotting

### Model Parallelism (2024.11.16)

- Fully Sharded Data Parallel
  - Paper from Meta AI arXiv:2304.11277
  - Parameter prefetching
- Overlap communication with computation
  - Operation reordering — hard! requires passing activations
- In OCANNL, easy to manually partition a model into components and explicitly distribute over devices and backends.
  - More natural for pipeline parallelism
  - Awkward/hard for model parallelism, especially for parameter sharding
- We need good design for initialization
- Tensor parallelism
  - In OCANNL, activations are typically a special case of non-materialized tensors
  - Rethinking design: non-materialized tensors vs the eviction mechanism

### Parameter Sharding (2024.11.18)

- Fully Sharded Data Parallel
  1. Each sub-module / model layer is a FSDP unit.
  2. Each unit's non-shared parameters are flattened, concatenated and sharded across backends/devices.
  3. Before the unit's computation, unshards required parameters. Afterward, deletes other shards' parameters.
  - Communicates parameters & their gradients on demand, for unsharding & accumulation
  - Crosses abstraction levels: bad fit for OCANNL design
  - Great for balancing memory, computation, number of devices
- Tensor Parallelism
  - Communicates activations: computation boundaries
  - Upside: keeps model design clean
  - Downside: complicates model design with computational considerations
  - Manually: a slice operator indexed by backend/device/stream
    - Hard work: find good axes to balance memory, computation, number of devices
    - Fits with OCANNL design
  - Automatically find good axes — tricky, worse fit for OCANNL design

## Ideas for Upcoming Mind Maps (2024.11.19, updated 2024.11.27)

### Ideas for Upcoming Mind Maps (2024.11.19, updated 2024.11.27)

- Convolutions and padding — 1/3 done: tinygrad
  - Design risk: interacts with the whole OCANNL, esp. shape inference
  - Even LLMs: need padding
  - Visually attractive examples
- Pipeline parallelism — mostly done
  - Continues recent theme
- Program search in tinygrad — done
  - Super important for design
- Pallas: extension of JAX for writing custom kernels — done
  - Mutable abstraction layer for JAX
- What are blocks? (added 11.27)
- More deep dives
  - Karpathy's: llm.c, llama2.c, LLM101n, nanoGPT
  - jackpeck's llama2.ml
  - Keller Jordan's modded-nanogpt
  - keras → keras.core

## Pipeline Parallelism and Optimizer/Gradient Sharding (2024.11.20)

### Pipeline Parallelism and Optimizer/Gradient Sharding (2024.11.20)

- Papers to read: ZeRO arXiv:1910.02054, Zero Bubble arXiv:2401.10241, NanoFlow arXiv:2408.12757
- Pipeline parallelism
  - Pipeline with nano-batches at the granularity of operations
  - PP most helpful for cross-server connections
  - Asynchronous PP breaks optimizer semantics
  - Zero Bubble
    - Optimizes microbatch scheduling of Forward, Backward, and Weight-gradient
    - Layer-wise parallelizes the optimizer step by accumulating progressively
    - Propagates global optimizer state of previous iteration while the next iteration is computing the initial forward steps
    - Redoes the optimizer step if a global check fails for any layer (found INF, NaN, or gradient clip needed)
- Optimizer/gradient sharding
  - ZeRO: focus on minimizing per-GPU memory
  - ZeRO-DP is similar to FSDP, but lossy and much simpler
    - Partitions optimizer states, discards gradient parts for other partitions
- More notes coming

## Tinygrad Deep Dive (2024.11.21 – 2024.11.27)

### Program Search in Tinygrad (2024.11.21)

- Kernel transforming operations — operations usually have axis and amt (amount / part of):
  - `LOCAL` — converts part of a global axis to local
  - `PADTO` — adds padding to an axis
  - `NOLOCALS` — prohibits use of local axes
  - `GROUPTOP`
  - `UPCASTMID`
  - `GROUP` — related: fusing reduce ops??
  - `TC` (TensorCore)
  - `UPCAST` — converts part of an axis into an innermost upcasted axis
  - `UNROLL` — converts part of or whole axis into an innermost upcasted axis
  - `SWAP` — swaps two axes in a tensor
- Upcasted axis is computed or reduced at higher precision??
- In tinygrad, memory mode and projection semantics are assigned per-axis
- Axis color coding: blue = global dims, cyan = local dims, green = reduce-local, white = reduce-late upcasted, red = reduce loops, purple = reduce upcasted, yellow = normal upcasted
- TensorCore's reduce axis is selected starting from `first_reduce`, the 2 inputs axes ending at `first_reduce`
  - Applying TC applies PADTO, UNROLL for reduce axis, UPCAST, LOCAL for TensorCore's threads' axes
  - Then optional "hand-coded" UPCAST and LOCAL
- All of this is in `codegen/kernel.py`, beam_search itself is in `engine/search.py`

### Scheduler in Tinygrad (2024.11.22)

- Why is all this in here? Where is the scheduling? — `schedule.py`: things to schedule, not scheduling
- `to_uop` for non-const buffers is the ShapeTracker's view of the buffer
  - An UOp `is_scheduled` when the op is `Ops.VIEW`
- Selects groups to fuse, vs. what to materialize — via graph rewriting
- Prepares indexing (aka. movement ops), integrates indexing with computation
  - What is sizzle??? → see later
- `ScheduleItem` with disjoint input and output buffers
  - Similar to OCANNL's inputs and outputs fields in `routine`
  - Multiple outputs possible via `Ops.SINK` AST node, otherwise single output
- Upcoming design (PR 7065)
  - Gets rid of `LazyBuffer` (replaced with `UOp`) and of `engine/lazy.py`
  - Gets rid of indexing processing in `schedule.py`, instead exposes `ShapeTracker` methods in `ops.py`
  - Tracks materialized buffers (i.e. `realized` in tinygrad) in `ops.py`
  - Graph rewriting to push views below computations, collect buffers and kernels — in `schedule.py`

### Pallas: a JAX Kernel Language (2024.11.23)

- On TPU: args are already SRAM (copied before running a kernel), then copied explicitly into registers before computation
- On GPU: args are HBM/DRAM mem (global), explicitly copied into SRAM mem (local) before computation
- Imperative: explicit assignments
  - `Ref`s were introduced to make JAX stateful even before Pallas, reused
- Kernels parallelize over grids
  - `vmap` of `pallas_call`: adds extra grid axis
- A `BlockSpec` projects an input or output to a block-slice view and threads/streams, for blockwise parallelism over grids
  - Manually specified for each input & output
  - Generalization of tiling
  - Dynamic slicing and masking
  - Also needs explicit `out_shape`
  - Not implemented yet: alternatives to `BlockSpec` e.g. overlapping windows for convolutions
- **Doesn't** support: `conv_general` etc. — usually not on hardware; `gather`/`scatter` — backends without noncontiguous memory reads/writes
- GPU and TPU are not entirely interchangeable?
- More control over memory access (on GPU)

### Triton (2024.11.24)

- Based on pointers
  - Pallas exposes them but on refs
- `load`, `store` with dynamic slicing and mask
- Nice idea: associate axes with strides to decouple tensor semantics from memory layout
- Sharing code across backends (CUDA, CDNA) but dedicated sections to compute e.g. num of threads per multi-processor
- Execution over a grid, as in CUDA and Pallas
- Both manual and auto-tune splitting into warps
  - Autotune picks a config out of manually speced candidates
- Each block must have 2^n elements, needs padding via mask
- Manual decoding of indices into per-block vectors of offsets for load/store, but otherwise functions over ndim arrays
- Nice tutorials
  - Maybe worth replicating `triton.testing` (`perf_report`|`Benchmark`)
- Groups of blocks reduce memory transfers per same num of output blocks
  - Not built-in
- `tl.exp` is `__expf` from CUDA (approximate)

### Triton Part 2 (2024.11.25)

- Counter-based Parallel Random Numbers
  - Computes pseudo-random nums on the device with seed int32
- Reducing across blocks in a group — manual, by locking at the end of a kernel
- Vs scheduling DSLs
  - Separate algo and schedule: tile splits, loop reordering and unrolling, parallel axes
  - TVM has built-in automatic scheduling
- Vs polyhedral DSLs
  - Use affine *access functions*
  - Support fusion, interchange, tiling, parallelization
  - Loop transformations
  - Large search space
  - Not applicable to (structured-)sparse networks
- Manual optimizations:
  - Coalescing — orders threads within micro-tile to contiguous mem access
  - Thread swizzling — transforms row-major to column-major submatrix for each group-size rows
- Auto optimizations:
  - Pre-fetching
  - Async copy scheduling
  - Shared mem synchronization — inserts barriers into GPU code by detecting read-after-writes and write-after-read

### Tinygrad ShapeTracker (2024.11.26)

- Pure movement ops: RESHAPE, PERMUTE, PAD, EXPAND, SHRINK, STRIDE
  - PAD — fwd: NumPy pad, bprop: shrink
  - EXPAND — fwd: NumPy `broadcast_to`, bprop: reduce SUM
  - SHRINK — fwd: NumPy subarray view, bprop: pad
  - STRIDE — decomposed using Flip for < 0 and a combination of Pad and Reshape for > 1
- Translates all of NumPy syntax to ops
- Vs teenygrad = 1/10th of tinygrad
- Is a list of View objects
- A View has: shape (i.e. dims), strides, offset, mask (begin-end per axis), whether it's contiguous
  - Default strides assume shape is rightmost-major
  - Canonicalized, e.g.: if mask uncovers just 1 index, convert to "no stride" and adjust the offset
- Why many views per Tracker? → tomorrow
- Direct relevant ops are: EXPAND, CONTRACT, VIEW, REDUCE_AXIS
- Assigned to op nodes except DEFINE_LOCAL/GLOBAL/VAR, BUFFER, CONST
  - VIEW has a ShapeTracker
  - Other nodes inherit ShapeTracker from children; all children must have the same ShapeTracker!
- VIEW = non-copy movement op; VIEW doesn't have children, instead typically provides a view for the preceding DEFINE_GLOBAL

### Tinygrad Followup (2024.11.27)

- `MultiLazyBuffer` with per-device `LazyBuffer`s
  - Stores per-device bounds of the sharded axis
  - Dedicated float4 support
- Multigpu via sharding
  - Ends up duplicating the part of the compute graph below reducing of the sharded axes
  - Its `ScheduleItem` forms a kernel
  - STORE: retain after kernel finishes
- `DEFINE_GLOBAL` args: position in parameter list, param name, mutability
- CAST and BITCAST
  - BITCAST first takes address and pointer-casts the address
- UPCAST UOp actually means UNROLL!
  - What is UPCAST Opt (i.e. in program search)?
- Variable
  - Axis dimensions placeholder
  - Has range — this range is used to render loops in Linearizer
  - Can remain symbolic
    - Generates symbolic mask guard
    - Passed as a kernel param
  - Can `create_schedule_with_vars` perform some shape inference?
