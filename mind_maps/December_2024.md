# Mind Maps — December 2024

## Keras Deep Dive (2024.12.17 – 2024.12.19)

### Keras First Impressions (2024.12.17)

- Design principle: progressive disclosure of complexity
- Backends: JAX, Tensorflow, PyTorch — only one per import
- Works with NumPy, Pandas, Tensorflow `Dataset`, PyTorch `DataLoader` regardless of backend
- Packaged with popular dataset ~~downloaders~~ pipelines
- Model-centric
- Models are similar to layers but can have component models
- The layer abstraction
  - `init` with configuration, `build` if it has persistent data/params depending on input shape, `call`
  - With `Input` layer builds automatically, without it build manually with batch input shape

```python
model = keras.Sequential([  ...list of layers...  ])
model.compile(loss, optimizer, metrics)
callbacks =
    [ModelCheckpoint(..), EarlyStopping(..)]
model.fit(x_train, y_train, batch_size,
          epochs, validation_split, callbacks)
score = model_evaluate(x_test, y_test)
model.save("final_model.keras")
predictions = model.predict(x_test)
```

### Keras Styles: Sequential, Functional, Subclassing (2024.12.18)

- In OCANNL, a tensor expr. function shares weights, a layer / block with `~config` does not
- Reusing a layer expression in different models does not share weights, in same model shares weights
- Composing with a model shares weights
- Functional API = layer expressions instead of `Sequential`
  - Model inputs can be a list, outputs can be a dictionary
- For cyclic or recursive computations: subclass `Model`
- Can mix-and-match Sequential, layer expressions and subclassing — via composing (sub)models
- Saved model includes: architecture (layer expression), weight values (params), training config, optimizer and its state
- Auto-propagated `call` args: `mask` (bool tensor if model input shape, regenerated per-call), `training` (train vs. inference, handled by built-in train, eval, predict loops)
- Layers and models have a `trainable` flag — individual weights can also be non-trainable
- Layers can `add_loss` to models that use them
- Upcoming: training and eval, distributed training

### Keras Training (2024.12.19)

- Data sources i.e. input pipelines are iterator-based (except NumPy), offer batching and shuffling, keras-specific one is multicore
- Sample weights: per-sample influence on loss
- Class weights: balance classes without resampling
- Dynamic learning rate schedules are callbacks that modify the optimizer
- Callback class has methods specific to: begin/end of whole/batch/epoch of train / test i.e. eval / predict i.e. infer
- Ideas for callbacks: checkpointing, early stopping, changing learning rate when plateau, fine-tuning of top layers when plateau, emailing on performance thresholds, TensorBoard, CSVLogger
- For saving/loading, custom layers etc. must define `get_config`, usually captures init arguments
- Progressive intervention into a model's training:
  - Override `train_step` and/or `test_step` (of eval) using model's forward-call and loss interface
  - As above but inline loss
  - Write the training and/or eval loop from scratch
  - Allows e.g. subclassing a GAN model
- Examples generate the derivative at each train step
- JAX example jit-compiles the full train step

## Distributed Training (2024.12.20 – 2024.12.23)

### Keras Distributed (2024.12.20)

- OCANNL's `DeviceMesh : dev` — grid configured manually but sharding done by program search; per-cluster mesh config passed to the mesh backend functor
- In OCANNL, better fit to link DeviceMesh with a routine rather than a tensor
- Same as `tensorflow.dtensor`
- `DeviceMesh` — organizes devices into N-dim grid with `axis_names`
  - Is synchronous — no events
- `TensorLayout` — assigns axes of any tensor (positionally) to sharded on a given mesh axis, or replicated
  - Tied to a `device_mesh` (might initially be unset)
- `DataParallel` — automates setting the layout
  - `batch_dim_name` specifies the data parallel part of the layout
- `ModelParallel`
  - `LayoutMap` — a fuzzy (regexp) map from parameters (weight variables) to `TensorLayout`
    - Can contain the default `device_mesh`

### JAX Distributed (2024.12.21)

- Counter-based PRNGs are better for parallelism
- Sharding mesh + `PartitionSpec` (like `TensorLayout`) = device-like
- `Array`: like DTensor
- `shard_map` takes a mesh and partition specs for inputs and output
  - Mapped func result shape must have rank sufficient for concatenation of sharding axes in output partition spec
  - Partitions tensors preserving the ranks (i.e. nums of axes)
- Unassigned input axes are replicated / tiled as in DTensor
- Layout propagation / inference
  - Inferred layout of outputs minimizes copying
  - Error when explicit layouts of inputs disagree
  - Default layout inputs can be moved and resharded automatically to fit other inputs
- Unassigned output axes are un-replicated: result is selected from just a subset of devices, assuming that it's the same on other groups of devices
- `with_sharding_constraint` redirects layout inference
  - Caller can pick mesh axes that are propagated rather than set manually on inputs / output

### JAX Collectives and NN Parallel Patterns (2024.12.22)

- JAX collectives — communicate across devices from within `shard_map`
  - `all_gather` — concatenates blocks along an axis, replicating a tensor
  - `psum` — replicates the summed axis
  - `ppermute` — sends tensor(s) by permuting a mesh axis
  - `all_to_all` — transposes blocks along an on-device and a cross-device axis
  - `psum_scatter` — = ppermute + add, no replication
- For best shift perf on TPUs, split blocks in half and shift bidirectionally
- NN parallel patterns in JAX
  - Data parallel — shard data on a batch axis, `pmean` the loss
    - FSDP — also shard params, on the batch mesh axis
    - `all_gather` inside predict, `jax.remat` to re-gather on backward pass
    - Other sharding is automatic
  - Tensor parallel — shard data and params on corresponding features axis, `psum_scatter` activations
    - FSDP + TP — explicit psum for features (in TP automatic sum→psum)
  - SPMD pipeline parallel — for same structure layers: `shard_map` over concatenated params, `ppermute` to advance the pipeline
- To overlap comp. and comm. reshape to add an axis and loop over it inside the map — if not overlapped by XLA

### JAX Distributed Multi-Host (2024.12.23)

- Very restrictive approach: SPMD (all processes same computations), all processes same number of devices, all devices the same (e.g. H100)
  - But allows running `shard_map` etc. without changes
- Processes must agree on per-device sizes
- Control flow must not diverge, watch out: length of training loop, iteration order
- Each JAX process runs independently, no one controller but one coordinator
  - Death of any process kills others
- NVIDIA backend: Collective Communications Library NCCL
- JAX integrates with `tf.data.Dataset`
- Sometimes the storage locality disagrees with computation locality — load `jax.Array` with storage sharding, and add `with_sharding_constraint` for efficient resharding

## XLA (2024.12.26 – 2024.12.27)

### XLA Instruction Set (2024.12.26)

- `XlaOp` = tensor
- Control-flow-like: `Conditional`, `While`
- `Clamp` to min/max
- `AfterAll` for sequencing (like tensor-centric events)
- `OptimizationBarrier`
- Cross-replica: `AllGather`, `AllReduce`, `AllToAll`, `CollectivePermute`, `ReduceScatter`
- `Scatter`, `SelectAndScatter`: non-deterministic loop of updates
- `Recv` and `Send`: communicate via shared channel
- `Infeed`: reads a tensor from an implicit channel on a device
- Persisted autotuning: cache on disk for speed and determinism
- Vectorized: `Reduce`, `Map`
- Tensor structure: `Transpose` (permute axes), `Collapse`, `Broadcast`, `Concatenate`
- `Gather` general idea: convert a list of offsets into tensors into a tensor with a new batch dimension
- `Iota`: constant literal initialized on device without transfer
- `CompositeCall`: to define composite functions
  - Can define asynchronous funcs: start, update loop, done
- Domain- or algo-specific: `BatchNormTraining/Grad/Infer`, `ConvWithGeneralPadding`, `Fft` (forward and inverse Fourier), `Cholesky`, `TriangularSolve`
- Also arithmetic

### XLA Emitters (2024.12.27)

- 3 compilation routes: libraries like cuBLAS & cuDNN; tiling followed by Triton; Emitters
- Partitioning: tensors are emitted in a single function when they interact pointwise without duplication
  - Subkernel function inputs: "inflow" tensors and indices of "outflow" tensors; outputs: "outflow" values at the indices. Kernel function: takes both "inflow" and "outflow" tensor args.
  - Only single-call functions are inlined
- Loop emitter is default (no "hero")
- Transpose and Reduction emitters, using shared memory
  - Two loops: coalesced reads to shared mem; then `sync_threads`; then coalesced writes
- Other emitters: Concatenate, Dynamic Update Slice, Input slices, Scatter
- Symbolically computes indexing maps between tensors, e.g. input↔output
  - For reasoning on mem. coalescing and tiling propagation
  - For emitting index transformations (transpose, broadcast, reshape, slice, reverse)
  - Only contiguous accesses get inlined as transfer reads
- Loop traversals linear in output tensors for coalesced writes, with boundary checks inside
- Tensors flattened to 1D as in memory
- Loop unrolling
