# Mind Maps — March 2025

## CUTLASS and CuTe (2025.03.04 – 2025.03.08)

### CUTLASS: C++ CUDA Templates for Linear Algebra Subroutines (2025.03.04)

- Python interface
  - Brief code thanks to good defaults
  - Brief but very informative error messages compared to C++ template compile errors
- Tiling as dividing shape by shape, or layout by shape
  - Facilitate working with tensor cores
- Tiling compute resources
- Layout algebra: composing layouts (as projections?)
  - Nested layouts aka modes: subset of axes, have specific semantics e.g. for threads, tensor cores
  - Also with swizzle functors
  - Compile-time checks for static parts of layouts
- `layout = (shape) : (stride)`, concatenable ("multiply")
  - Tile: shape changes, but not stride
- CuTe: C++ CUDA Template Library for Tensors
  - Front-end to CUTLASS 3.0
- Conceptual GEMM Hierarchy
  - Atom layer — centered around hardware-accelerated ops e.g. tensor core, vector op
  - Tiled MMA/Copy — centered around optimal use of a single GPU
  - Collective layer — centered around synchronization
  - Kernel layer — grid planning, load balancing, thread marshalling
    - Device layer
      - Host-side

### CUTLASS / CuTe Layout Algebra (2025.03.05)

- Mode of layout = axis = length-1 layout
- *Coordinate* = logical position in shape: natural (aka h-D), or colexicogr. ordinal (aka 1-D), or mixed (sub-shapes → ord.) (aka R-D, R=rank); *natural coordinate* = same (nested) tuple as shape; *index* = offset in layout (inner product of natural coordinate and stride)
- Confusing: formalism and default stride is column-major (colexicographical)
- Tuple-like and NumPy-like operations: sublayouts (fully expressive), concatenation, grouping, flattening, slicing
- Complement
  - Left/right inverse
- Composition
  - Logical product
    - Logical divide
    - Zipped, tiled

### CuTe Layout Algebra — Continued (2025.03.06)

- Coalesced layout: remove modes (axes) of size (dim) 1, remove modes that traverse contiguously with the preceding mode: `(s0:d0, s1:s0*d0) --> (s0*s1, d0)`
  - Sorted layout: strides are non-decreasing
- Complement of layout A wrt. size M: layout B such that (A, B) (concatenated) is contiguous (dense) of size M; i.e. B fills the gaps of A due to strides
  - B by itself has its image disjoint from A except for position 0 — because of disjoint coordinates when embedded in C=(A,B)
- (Functional) composition of layouts: `R(c) := (A ∘ B)(c) := A(B(c))`
  - R has coordinates compatible with B
  - `(s0:d0) ∘ (s1:d1) = s1:(d0*d1)` — every d0th element, s1 total
  - Composition is left-distributive with concatenation, so focus on B with 1 mode
  - Coalesce `A` and let `B=N:r`, then `A ∘ B` has the modes (dimensions and strides) from the middle of `A` with first and last mode adjusted, such that `size(A ∘ B)=N`, and the first stride = the corresponding stride of `A` * (`r` / the cumulative size of modes to the left)

### CuTe Layout Algebra — Continued (2025.03.07)

- `complement(A,M)` has one more mode than A: leading mode (d0:1) where d0 is leading stride of A; except d0=1 → same num of modes
- A ∘ B selects parts of A and reshapes them
- Tilers add expressivity via hierarchical layouts:
  - Layouts: `A ∘ (B1, B2) = (A ∘ B1, A ∘ B2)`
  - Tilers: `(A1, A2) ∘ <B1, B2> = (A1 ∘ B1, A2 ∘ B2)`
- Logical divide: `A / B := A ∘ (B, complement(B, size(A)))` — split A into elems pointed to by B, and the rest
  - In the hierarchical layout of A/B, the first toplevel mode is the tile, and the second is the iterator over tiles
  - Logical dividing by a tiler keeps the hierarchical structure: `(A1, A2) / <B1, B2> = (A1 / B1, A2 / B2)`
- Zipped divide: puts the iterator modes coming from different pieces of the tiler into one toplevel sublayout
- Tiled divide: puts the intra-tile modes of the tiler pieces into one toplevel sublayout
  - `layout<0>(zipped_divide(A, B)) = layout<0>(tiled_divide(A, B)) = A ∘ B`
- Dividing by a multimode tiler: multidim tiles that look differently for different modes (axes) of A
- Logical product: `A × B := (A, complement(A, size(A)*cosize(B))) ∘ B`
  - A is the tile, B is the number and order of repetitions, A* is the available repetition layout
  - `logical_product` is tricky because B needs to be designed for A; `blocked_product` simplifies this
  - `raked_product` disperses the tiles

### CuTe: Tensors and Algorithms (2025.03.08)

- `tensor = layout + engine + [non]owning`; `engine = RAM iterator + mem tag`; `mem tag = global | shared | registers`
- Thread-Value partitioning: a layout mapping threads + per-thread values to coordinates
- Tensor slice: new non-owning tensor with offset iterator, and new (restricted) layout
- Partitioning: `zipped_divide` then slice; `inner_partition`, `local_tile`: give each e.g. threadgroup a tile; `outer_partition`, `local_partition`: iterate at fixed position / slice of the tiles
- Since CuTe can represent datatype, mem tag, shape and stride at compile time, algorithms can specialize to hardware-specific instructions
  - The type-inferred default impl can be overridden
- `copy`: the compiler-selected impl. may need a specific explicit synchronization
  - `copy_if`: copy with a mask tensor
- `axpby`: `y := a*x+b*y` (generalizes FMA)
- `gemm`: accumulating, one of: element-wise product, outer product, batched outer product, matrix product; selected by a type param
- `fill`, `clear memory`
- Generics: `transform` (map in-place), `fold` an operation (C++17 style)

### CuTe Matrix Multiply (2025.03.10)

- Mnemonic: `D := A*B + C`
- Hardware instruction levels:
  - Single thread (e.g. FMA)
  - Quadpair (Volta: V100) — kinda 8 thread tensor core, i.e. 4 QPs per warp; QP 0 is threads 0-3 & 16-19 etc.
  - Single warp (Ampere: A100, RTX 30x0)
  - Warpgroup (Hopper: H100) — not introduced, but much optimized
  - 128 1D threads
- MMA and Copy atoms: expose specific PTX instructions with a unified, templated interface
  - For a specific PTX operation, provide A,B,C,D types and layouts
- M/N/K-major: has stride 1 in the M/N/K mode
- Often represents inputs as (M,K),(N,K) rather than (M,K),(K,N)
- Simplest example: tiles over threadblocks aka CTAs

```cpp
auto cta_coord = make_coord(blockIdx.x, blockIdx.y, _);
Tensor gA = local_tile(mA, cta_tiler, cta_coord, Step<_1,X,_1>{});
```

- Static templated args e.g. bM=128 × bN=128 × bK=8
- Selects sublayouts except for pos. X for both `cta_tiler` and `cta_coord`
- Example: independently specifying shared mem layouts, partitioning patterns, PTX instruction via `TiledCopy` and `TiledMMA`

```cpp
auto tA = make_layout(make_shape(Int<32>{},Int<8>{}));
Tensor tAgA/tAsA = local_partition(gA/sA, tA, threadIdx.x);
...  copy(tAgA(_,_,k_tile), tAsA); cp_async_fence();
     cp_async_wait<0>(); gemm(tCsA, tCsB, tCrC); __syncthreads();
```

- Builders take `Copy_Atom<...>` / `UniversalFMA<TC,TA,TB>` and threads (and values for `TiledCopy`) layout(s), then `TiledX.get_slice(threadIdx.x)` to extract `tAgA`, `tAsA`, `tCsA`...

## The Ultra-Scale Playbook (2025.03.24 – 2025.03.26)

### Table of Contents (2025.03.24)

- One GPU training
  - Profiling compute and communication
  - Recomputing activations
- Data parallelism
  - Overlap grad reduction with backward pass
  - Bucket grads into concat tensors for reduction
  - ZeRO: 1 (optim. states), 2 (+ grads), 3 (+ params)
- Tensor parallelism — along hidden dim
- Sequence parallelism — along input dim
- Context parallelism
  - Ring attention
  - Zig-zag ring attention
- Expert parallelism
- Pipeline parallelism
  - Zero Bubble and DualPipe
- Fusing, threading, mixed precision
  - Flash Attention 1-3
- Finding best training config
  - Step 1: fit step in mem
  - Step 2: target batch size
  - Step 3: throughput

### Picotron (2025.03.26)

- Vocab embedding
  - Mask input on GPU to only compute what's in the GPU's dictionary
  - And shift
- Tensor parallel
  - Split is best: first by columns, then by rows (matmul → nonlin → matmul; output proj.)
- Parallelisms (example: 8× parallel total): data → batch dim (DP=2), tensor → hidden dim (TP=2), pipeline → model layer dim (PP=2)
- Process group manager
  - PP\*TP\*DP grid of GPUs
  - Selects subsets of GPUs for a given parallel schema
  - Sets up one process per GPU
- Dataloader
  - `tokenize_dataset`
- Data parallel
  - Distributed sampler
  - Dataparallel buckets
  - `all_reduce` to average gradients
- Grad accumulation: reduce mem by not parallelizing over the whole batch
  - Manual `grad_acc` in a temp var to reduce at higher prec FP32
