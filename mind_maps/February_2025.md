# Mind Maps — February 2025

## Tinygrad's Centralized Gradient (2025.02.01)

- Tinygrad decomposes them so there's only "reciprocal", but it's a slight loss of expressivity (and convenience!) wrt. "to-power-of"
  - In OCANNL it would be slightly harder to do complex gradients like "to-power-of" and "division"
- Reduces the scope of the tensor class a bit but tensors still have grad field — no need to centralize for that
- Inspiring: instead of tracking backprop at the assignments level, track it at the tensor expression level like in tinygrad
- We get rid of the diff / non-diff distinction, replace `diff : diff option` by mutable `diff : diff option`, and `type diff = { grad : t; zero_grads : asgns }`
  - It shouldn't reduce flexibility since the new `grad.forward` would function like the old `diff.bprop`
- We will still use the global session state: to update the diff field
  - i.e. there will still be an implicit set of differentiated roots; later, we could refactor that too

## Polyhedral Optimization (2025.02.02 – 2025.02.06)

### Quick Glance at Polyhedral Optimization (2025.02.02)

- Sources: PLISS 2019 Polyhedral Compilation lecture slides (includes a mini primer on MLIR); PolyTOPS: Reconfigurable and Flexible Polyhedral Scheduler
- Optimizing nested loops by affine transformations of loop variables
- Polyhedra are a technical detail
- Tiling, Loop Fusion and Fission
- Here dataflow perspective: T: topology with nodes-cols and buffers-rows; v: node firings; $T v = 0$: no deadlock or buffer overflow; $v_c > 0 \; \forall c$: no starvation
- ISL: integer set library
- Schedule: map from timestamp to iteration domain (using lexicographic order)
- Construct a producer/consumer dataflow diagram, reorder for locality, and compactify buffers by reusing already-read cells
- Optimal solving is too hard, and efficient code generation from a solution is too hard
- Simpler — synchronous dataflow: + finds efficient, deadlock free schedules; − limited solutions: $S_p(x) = q_p \cdot x + d_p$; − same amount of data at each node. q: rate, d: delay, p: producer, c: consumer
  - For example, minimize: $q_p, q_c, d_p, d_c$ subject to: $q_c \cdot x + d_c \geq q_p \cdot x/2 + d_p$

### Polyhedral Optimization Framework (2025.02.03)

- Iteration domain: space of all executions of statements i.e. single-cell assignments
- Schedule = maps iteration domain to execution times preserving lexical order
  - Actually lines are also lexicographic: output dims, input dims
- Loops introduce one dimension to the iteration domain per nesting depth
- Statement sequences introduce one dimension per sequence at nesting depth ("unrolled loop")
  - Called β-vectors if every other dimension is for sequencing, and uniquely identify share merits
- Reuse — temporal vs spatial locality, cache lines
- Valid schedule: dependencies have lexico-positive distance, schedule is invertible — anyway causality preserved
- Parallelism: benefit distance-0 dependences
- Code generation: invert the schedule; affine eqs. and ineqs. schedules invertible (Gauss Elimination, Fourier-Motzkin)
- Optimizing schedule: ILP using heuristic objectives (trying to approx. performance on idealized hardware); or discrete search with benchmarking JITted solutions
  - When ILP, ensure invertibility e.g. iteratively optimize over rows adding constraints to keep full row rank
- Reuse: benefit accesses not using iterators from the last schedule dimension
- Fusion (when the sequence dim difference is zero): penalty for fissioned statements sharing a data cell, OR penalty for fused statements not sharing any data cells
- Vectorization: penalty for iterator in the fastest-varying array subscript and no others

### "Opening Polyhedral Compiler's Black Box" from Inria (2025.02.04)

- A statement can have multiple relations if disjunctive conditions in control flow
- Change in a scheduling relation = program transformation
- Requirements — invertibility not necessary: all relations have the same iteration domain; union of relations of a statement covers the iteration domain and is 1-to-1; all dates are (vectors of) integers — implies linear independence of dimensions
- Decodes optimized scheduling relations into a sequence of syntactic loop transformations
- Encodes loop transformations as updates of scheduling relations
- Syntactic transformations:
  - Reorder — changes sequencing
  - FuseNext — fuses a loop with its successor
  - Distribute — splits a loop in two
  - Interchange — swaps loops at given 2 depths in the given nesting
  - Shift — moves given statements by given amount in the given loop
  - Skew — scales the given **output** loop's iterator by given factor
  - Reshape — scales the given **input** loop's iterator by given factor
  - Reverse — reverses the iteration order for the given loop(s)
  - IndexSetSplit — partitions a scheduling relation into two disjoint ones, e.g. duplicates a loop with one up to midpoint, the next from midpoint
  - Collapse — reverse of IndexSetSplit
  - Grain / Densify — change how long it takes between two executions of the given statements along the given loop
  - StripMine — decomposes the given loop into 2 nested loops, with one exec of the inner loop iterating for at most the given steps. + Interchange = Tiling
  - Linearize — reverse of StripMine
  - Unroll/Parallelize — not a real transformation, marks the given output dimension for unrolling or vectorizing
- Transforms not needed for decoding: Interchange, Collapse, Linearize, Parallelize
- Grain + Reshape = Rotation: aligns a dependence along a loop
- "High performance compilers for parallel computing" M. Wolfe 1996

### Another Glance at MLIR: Multi-Level Intermediate Representation (2025.02.05)

- Typed Static Single Assignment, functional: instead of Phi functions, blocks take arguments
- Many improvements over LLVM
- Declarative general programming language with namespaces, pattern matching, rewrite rules
  - Combined with C++ code (tricky rewrite rules, passes, trait implementations etc.)
  - E.g. can define syntax of operations from within op. def.
- *Dialects* are centrally or externally maintained extensions — 48 dialects in the repository
  - Lowering sequence (all within MLIR): TensorFlow repr. → XLA HLO → Polyhedral/Affine → LLVM IR
  - nvgpu dialect — PTX specific operations
  - amdgpu dialect
  - llvm dialect
  - Affine dialect — "Polyhedral" / for-loop lang with first-class loop ranges
  - Linalg dialect — high-level hierarchical optimization for linalg ops, especially convolutions; Structured Abstraction
  - GPU dialect — launching kernels
  - shape dialect — shape inference
  - tensor type dialect
  - memref type dialect — views on arrays
  - Transformation
- Altogether 238 passes, e.g.: linalg-fuse-elementwise-ops, gpu-map-parallel-loops, affine-loop-tile, convert-gpu-to-nvvm, convert-amdgpu-to-rocdl, convert-affine-for-to-gpu, buffer-loop-hoisting, ownership-based-buffer-deallocation, loop-invariant-code-motion
- High-level support for H100: `nvgpu.mbarrier` ops (Arrive/Wait Barriers), `nvgpu.tma` ops (Tensor Memory Accelerator), `nvgpu.warpgroup` MMA ops
- Lowering sequence: nvgpu → nvvm → llvm → PTX

### PolyTOPS: Reconfigurable and Flexible Polyhedral Scheduler (2025.02.06)

- Very clean formal setup of polyhedral optimization, nice scheduler algo
- (Symbolic) iterators: $\vec{it}$; (symbolic) constants: $\vec{N}$
- Dependency S→R: statement S needs to execute before R to preserve semantics
- Iteration domain: $D_S = \{ \vec{it} \mid M_S \cdot (\vec{it} / \vec{N}) \geq 0 \}$
- Dependency legality: $\delta_{S \to R} = \{ (\vec{it}_S / \vec{it}_R) \mid M_{S \to R} \cdot (\vec{it}_S / \vec{it}_R / \vec{N}) \geq 0 \}$
- Scheduling function: $\Theta_S : \vec{it} \mapsto (\phi_{S,0}(\vec{it}), \ldots, \phi_{S,m-1}(\vec{it}))$; $\phi_{S,i}(\vec{it}) = \lfloor S_i \cdot (\vec{it} / \vec{N}) \rfloor$ (vector)
- PolyTOPS builds ILPs one scheduling dimension at a time, from outermost
  - $(\vec{it}, \vec{it}') \in \delta_{S \to R} \Rightarrow \phi_{R,i}(\vec{it}') \geq \phi_{S,i}(\vec{it})$
  - More efficient but doesn't encode global cost functions
- Supports user-defined constraints, cost functions
- Tiling, skewing and intra-tile optims are not done by ILP → postprocessing at each step
- Predefined cost funcs:
  - proximity — temporal locality
  - contiguity — spatial locality
  - feautrier — find sequential outer dimensions that carry the most dependencies — enables inner loop parallelism / vectorization
  - AutoVectorization — which loops should be innermost and unfused, based on mem stride and accesses
  - bigLoopsFirst — loops with largest domains outermost
  - directives — specify that a loop should be parallel / vectorized / sequential, if possible

## Second Glance at Caten (2025.02.07)

- https://github.com/hikettei/Caten
- C, Lisp, JS/WebGPU runtimes
- Has frontend but can also load ONNX graphs
- Renamed shape-inference to type-relay, handles shape, stride, iter spaces (i.e. OCANNL's projections)
- Caten Compiler End-to-end pipeline:
  - **Frontend**: High Level APIs (caten/api) → Decomposing → Primitive Ops Graph (caten/aasm)
  - **Scheduling**: Schedule Graph (caten/codegen) → Extracting SCoP → Polyhedral IR (codegen/polyhedral)
  - **Backend** (Configuration via caten/byoc): Optimization Strategy → Generate Sketch → BEAM Search / Profiling → Abstract Runtime
  - Hardware Specific Optimized Code → Optimized Abstract IR (codegen/blueprint) → Rendering → Optimized Kernel Code
- Compiler Workflow: Schedule Item → Extract SCoP → Polyhedral IR → Solving ILP (Maximize band depth) → Tile all bands → Packing (Microkernel applied) → Parallelize (Outermost band parallelized) → Sketch
- Configuration (BYOC):
  - Microkernel Rules: `<TensorCore (8 8 8) ...>`, `<Vectorize (8) ...>`, `<Upcast (8) ...>`
  - Parallelism Rules: `N_GLOBAL_DIMS=3`, `MAX_THREAD_SIZE=...`
- Mapping each band to parallelism — see https://github.com/hikettei/Caten/pull/422

## Integer Set Library (2025.02.10)

- For loop optimization
- Written in C, easy to bind deeply — distributed with a Python interface
- Well documented: a manual, and a tutorial on polyhedral compilation
- Continuously since mid-2008; actively developed, by Sven Verdoolaege, until release of 0.27 early September 2024
- Outdated bindings for OCaml, half-auto-generated — and generation from Haskell to OCaml :-)
  - I might rewrite the bindings incompatibly from CamelCase to Snake_case
- Could be interacted with via binaries (tools) but currently I prefer to integrate more tightly
- Three distributions / library options:
  - **isl**: the core polyhedral manipulation and solution / optimization
  - **barvinok**: dynamically-typed domain-specific programming language; tool **iscc**
  - **pet**: extracting (parts of) a polyhedral model from C code
- Integrate auto-tuning
- Try to figure out integrating inlining and memory mode decisions, so we get rid of code interpretation on the "pure" OCANNL side

## Tiramisu Polyhedral Compiler (2025.02.11)

- Written in C++; actively developed May 2016–Feb 2023
- 4 layer IR: algorithm, computation, data, communication
  - 1: instructions and producer-consumer dependences
  - 2: computation order; iteration space transforms (e.g. tiling); architecture (GPU, distributed)
  - 3: mem layout; buffer alloc and free
  - 4: sync and comms, within and between architectures
- Handles sparsity
- Integrated with ISL to for example express ASTs for CUDA; Halide IR is used for CPU ASTs
- Handles recurrent NNs and cyclic dataflows — via skewing
- Optimizes distributed code
- "A Deep Learning Based Cost Model for Automatic Code Optimization" — cost model architecture:
  - Computation Embedding Layer: feedforward NN on computation vectors (per statement A, B, C, D, E)
  - Recursive Loop Embedding Layer: LSTM over child loop embeddings and child computation embeddings → new loop embedding
  - Regression Layer: feedforward NN → predicted speedup
  - Computation vectors composed of loop nestings including loop transformations, and memory accesses, but padded to 1235 dims for feedforward NN embedding

## Autotuning / Program Search (2025.02.12 – 2025.02.16)

### Halide Program Search — Learning to Optimize Halide with Tree Search and Random Programs (2025.02.12–14)

- Autotuning / program search: here Halide (2019), next time Tiramisu (2021)
- Iterates through network layers from output
- Compute and storage granularity: how many loops to fuse, memory reuse: fusing all loops = inlining
- Add extra tiling to previous layer if it enables more choices
- Steps: (1) add inner tilings (opt. vectorized / SIMD), (2) outer tilings (opt. parallel threads); total 2*n* steps for *n* layers
  - Choosing each tile size
- Beam search: top-k for each step
- Cost model trained on full pipelines; implicitly assume unscheduled layers are inputs; when interdependent, assume max locality and dense vector loads (optimistic)
- Pruning: limit search space, e.g. loops compute→storage should be single-dimensional (best results for line-buffer)
- Coarse-to-fine: diversify the beam by prioritizing one representative of a loop nest class; next pass: only optimize within winning loop nest classes, with finer subclasses
- Heuristic instead of search: loop unrolling, no nest reordering except vector dims pushed inside, memory space selection
- Cost model and runtime to be continued
- See figure from yesterday (Tiramisu cost model)
- Algo and schedule features, computed statically:
  - Histograms of operations to compute a single point
  - Jacobians of input/prev-stage accesses wrt. loop dimensions (non-constant ignored assuming worst case)
  - Count of evaluations of a region, of allocations of storage for their result, of accesses of this storage: both in bytes and in contiguous segments
  - Number of parallel tasks launched
  - Number of whole SIMD vectors computed, and of the corresponding scalar values
  - Number of dense vectors and scalars loaded per vector computed (amortized over sharing by unrolled loops)
- Region shapes via symbolic interval arithmetic
- A small cost network: *features* → *coefficients* for simple manual heuristics, also built out of the features
- Beam search with "dropout": expand k-th best w/prob p^k
- Pretrained on random algos / networks
- Autotune: benchmark end-of-beam candidates; finetune: update model while beam-searching

### Tiramisu Program Search (2025.02.16)

- Searches for a sequence of transformations: fusion, tiling, interchanges, unrolling
- Heuristic / not optimized: parallelization, vectorization
- Recursive NN over a loop embedding: combines outputs of LSTMs
  - Loop children: LSTM over loop transformations
  - Statement children: LSTM over computation vectors
- Use of two LSTMs loses ordering info between nested loops and statements
- Computation vectors composed of loop nestings including loop transformations, and memory accesses, but padded to 1235 dims for feedforward NN embedding

## Matrix Multiplication (2025.02.16 – 2025.02.21)

### Matrix Multiplication on Multicore CPU (2025.02.16)

- Source: siboehm.com
- SGEM = single-precision general matrix multiply: a\*A\*B + b\*C
- The machine FMA is accumulating! c := a\*b + c; FMA = fused multiply add = MAC = multiply accumulate
- Uses vectorized FMA instructions
- Intel's MKL has dedicated SGEMM functions / kernels for each microarchitecture
- CPUs are compute bound even for small matrices
- `-march=native` specializes C compiler's output to microarchitecture it compiled on
- Big gain from loop reordering: non-contiguous iterator should never be innermost — much better than assigning to a register in innermost loop
- Tiling on multiple dimensions
  - Tiling the reduce loop (middle) with outermost replication
  - Idea: tile width so that a single tile of the reduce loop fits in cache; in practice the best size is bigger
  - It's two elementary loop transforms: strip-mine and reorder
- Multithreading strategy: tile rows of A and columns of B so that there's no need to communicate except to gather the results

### Matrix Multiplication in CUDA without Tensor Cores (2025.02.17–18)

- Source: siboehm.com
- We implement FMA / MAC: C := alpha A @ B + beta C
- cuBLAS at FP32 doesn't use tensor cores, only at TF32 and BF16
- Should be compute bound if well designed
- Kernel 1: each cell of C a separate thread doing reduction, thread ids end up increasing along columns of C; 1.3% eff.
  - No change in assembly, access coalescing at runtime, requires aligned access; compiler does partial inner loop unrolling
- Kernel 2: ensure thread ids increase along rows of C; 8.5% eff.
- Kernel 3: threads first populate shared mem, then sync, then reduce the shared mem block; 12.8% eff.
  - It's a strip-mining of the reduce loop, but tricky as pure loop transforms — kinda also strip-mining of A and B's non-shared axis (into block-parallel and thread-parallel) and promoting tiles to shared mem
- Kernel 4: kernel 3's thread-parallel A loop strip-mined to new innermost non-parallel loop, smaller tiling of reduce loop than kernel 3 to lower smem; 36.5% eff.
  - `__syncthreads` separates two implicit thread-parallel loops, but logically the thread-parallel iterators are different (the first loop's iter for A becomes the innermost non-parallel loop for A)
- Kernel 5: also strip-mine kernel 4's thread-parallel B loop to new innermost non-parallel loop; now too few threads wrt. tile size: smem copy loops; 68.7% eff.
  - Combats shared mem access bottleneck; why does the strip-mining halve threads per threadblock?
- Kernel 6: transpose a tile of A while copying to shared mem; vectorize copying via `reinterpret_cast<float4 *>`; 78.4% eff.
- Kernels 7 and 8: shared-mem bank conflicts
- Kernel 9: autotuning: how much data cached — from global to shared mem, from shared mem to register file i.e. local mem
- Kernel 10: warptiling: GPU → GMEM-to-SMEM → SM; SMEM-to-RegisterFile → Warp; RegisterFile-to-core → Thread
  - Each level of tiling is: strip-mining, reordering, preparatory loops for mem level transfer (sometimes with transpose)
- Kernels 11 and 12: double buffering
- Smem bank conflicts and double buffering continued after Sep. V notes on AMD GPUs
- Levels of parallelism: blocktiling (different Streaming Microprocessors, syncing and shared mem within tile), warptiling (different warp schedulers, mem bank benefits, warp-level ops e.g. tensor cores), threadtiling (Instruction Level Parallelism)
- CUDA compiler can do the ILP vectorization

### Matrix Multiplication on AMD RDNA3 GPUs (2025.02.19)

- Source: seb-v.github.io
- Nomenclature: Compute Unit = Streaming Multiprocessor; Stream Processor = CUDA Core; wavefront (32 or 64) = warp (32 threads); workgroup = block; Local Data Storage = Shared MEMory
- The programming model is almost the same, uses the same keywords e.g. `__shared__`
- Like before, we do C := a\*A\*B + b\*C in FP32 prec.; 32\*4 (b/c FP32) = 128 bytes mem transaction
- Kernel 1 is identical to CUDA; 3.3% eff.
- Kernel 2: LDS tiling; square As, Bs 32x32 of A / B, strip-mines reduce dim and reorders, loads the tiles As, Bs w/ transpose into LDS along rows of A, B; 13.1% eff.
- Kernel 3: register tiling adds 2 (3) more tiling levels: 1-per-thread increases arithmetic complexity and 2x2-per-wave enables vectorized mem transfers; loads a col,row of LDS tile to registers to reduce, strip-mines both tile dims
  - This is kinda swizzled layout
  - The wave tile is composed of 2x2 subtiles sized 8x4 that each fit in a wavefront (8\*4=32) (why?) doesn't prevent mem bank conflicts b/c accessed contiguously?
  - Also unlocks `v_dual_fmac_f32`: parallel vector multiply-accumulate operations
- Kernel 7 from siboehm.com prevents bank conflicts by dispersing consecutive Bs, so on reading to regs they're from the same bank
  - I don't see how kernel 8 from siboehm.com prevents bank conflicts?

### Matrix Multiplication on AMD GPUs: Double Buffering and Bank Conflicts (2025.02.20)

- Source: seb-v.github.io
- Needs `__launch_bounds__`, otherwise compiler uses scratch mem instead of registers
- Kernel 4: double buffering; load the next block's GMEM data into registers at the beginning of a step; sync at end of step and write to SMEM; also adds unroll pragmas; 83.7% eff.
  - While some threads queue for loading from GMEM, others continue computing
- Kernel 5: bank conflicts → adds padding to As rows (smem tile of A) so that accesses are staggered: original BM%32=0, new (BM+4)%32=4 no same-thread same-bank conflicts; arithmetic intensity → 2x wider wave tile; adds `-cumode` (each SIMD32 sticks to its own LDS); 109.8% eff.
  - Theoretically close to 200% eff. might be possible because for unknown reason rocBLAS is not using dual_fmac: 2x multiply-accumulate ops.

### Matrix Multiplication on AMD GPUs: from HIP to ISA (2025.02.21)

- Source: seb-v.github.io
- Nomenclature: HIP = CUDA; ISA = SASS (assembly); AMDIL / ROCm llvm IR = PTX
- Kernel 6: optimize vector arithmetics using `v_dual_fmac_f32`: maximize number of vec registers read per instruction; maximize use of cache; maintain a consistent symmetric access pattern; don't worry about contiguous use of registers: reorder before writing to LDS
  - Kernel 6 details: ensure C_regs contiguous, assign A_col and B_row to non-overlapping banks (0-1 and 2-3), update LDS loads and inner loop v_dual_fmac accordingly, permute registers as needed by code writing to global memory; 123.7% eff.
- Kernel 7: loop unrolling; didn't work with the HIP implementation b/c the compiler prefetched more values from the LDS; now just duplicate ISA loop body with address increments, remove branch instructions; 135.1% eff.
- Kernel 8: batched GMEM loads; precompute global load offsets into scalar registers (saving on vec registers); in the loop, update A,B index vec registers, `global_load_b32` output-reg, index-reg, offset-reg format; spread the loads across the unrolled inner loop; 160.6% eff.
- Remaining possible optimization: double buffering for LDS
- This approach is not scalable but gives insight into optimal execution on RDNA3

## The FineWeb Recipe (2025.02.22)

- OpenAI, Anthropic etc. use their own web crawlers and data
- Common Crawl is a non-profit org extracting data for researchers; currently over 250 billion pages; new crawls w/ 200-400TiB text every 1-2 months
  - CommonCrawl text extraction (WET) is poor quality; but text extraction is costly → redone
- FineWeb is derived from 96 CommonCrawl snapshots; has 15 trillion tokens; 44TB
- FineWeb-Edu: 1.3 trillion and 5.4 trillion tokens (very) high quality
  - Filtered by "educational content" classifier distilled from Llama-3-70B-instruct prompted to focus on grade/middle-school
- Data quality: train small models and evaluate on early-signal benchmarks
  - CommonSense QA, HellaSwag, OpenBook QA, PIQA, SIQA, WinoGrande, ARC, MMLU
- Base filtering: URL blocklists; English only (fastText classifier); repetition filter (many repeated lines); filters from MassiveText (used to train Gopher); 36T tokens
- MassiveText filters: docs between 50 and 100K words, mean word length from 3 to 10 chars, hash|ellipsis-to-word ratio < 0.1; less than 90% lines bullet points; less than 30% lines end with ellipsis; 80% words contain alphabetic char; contains at least 2 of: *the, be, to, of, and, that, have, with*
- Filters from C4 dataset: no "lorem ipsum" and no curly brackets
- C4 dataset inspired filters: docs with fraction of lines ending with punctuation > 0.12; docs with fraction of chars in duplicated lines > 0.1; docs with fraction of lines shorter than 30 chars < 0.67
- Deduplicating: MinHash based: 5-grams, 112 hash functions, 14 buckets; 0.85 similarity → 98.8% discard
  - Within-snapshot only; cross-snapshot-repeated data has higher quality, global dedup upsamples bad quality
