# Debugging and Profiling OCaml -- lessons (re)learned

## Links

* [OCaml.org tutorial on debugging](https://ocaml.org/docs/debugging)
* [ppx_minidebug](https://github.com/lukstafi/ppx_minidebug), a debugging and logging framework.
* [_Debugging Native Code Binaries_ in **Real World OCaml**](https://dev.realworldocaml.org/compiler-backend.html)
* [KC Sivaramakrishnan's _Getting Started with GDB on OCaml_](https://kcsrk.info/ocaml/gdb/2024/01/20/gdb-ocaml/)
  * [Deterministically debugging concurrent GC bugs with rr](https://kcsrk.info/ocaml/multicore/rr/2019/04/28/0000-rr-debugging/)
  * [15 minutes tutorial of GDB](https://www.youtube.com/watch?v=PorfLSr3DDI)
* [Javier Chávarri's _Profiling Dune Builds_](https://tech.ahrefs.com/profiling-dune-builds-a8de589ec268) -- a brief coverage of `perf` and `memtrace`
* [vg-b's workaround for some `perf` problems](https://discuss.ocaml.org/t/profiling-ocaml-programs/14033/4) (the need for `ocaml-option-fp`)
* [Tianyi Song's _Profiling OCaml programs the quick and dirty way_](https://tsong.co/blog/profiling-ocaml-quick-dirty/) about using [Landmarks](https://github.com/LexiFi/landmarks). Has precise timing (CPU cycles), both manual and automatic annotation (PPX based), callgraph visualization.
* [Debugging OCaml with Emacs](https://lambdafoo.com/posts/2024-03-25-ocaml-debugging-with-emacs.html) -- setting up bytecode and native debugging.
* [Bytecode debugging in OCaml 5.3](https://discuss.ocaml.org/t/bytecode-debugging-in-ocaml-5-3/16177)
* [Vincent Laviron](https://discuss.ocaml.org/t/bytecode-debugging-in-ocaml-5-3/16177/2) brings up [rr as an alternative to gdb](https://rr-project.org/). It's Linux only, it combines native debugging like GDB with tracing.
* [A tool to reverse debug OCaml/other binary runs](https://discuss.ocaml.org/t/ann-a-tool-to-reverse-debug-ocaml-other-binary-runs/16366) -- [Bringing Record and Replay everywhere](https://github.com/sidkshatriya/me/blob/master/008-rr-everywhere.md) by Sid Kshatriya

## Don't forget

* Use Valgrind to debug memory corruption.
  * Symptoms: random crashes in garbage collection, in `ctypes` code, in system libraries etc.
  * Example invocation: `valgrind --leak-check=full --leak-resolution=high --show-leak-kinds=all --errors-for-leak-kinds=none _build/default/bin/example.exe`
* Use GDB when the program hangs to quickly see the stack trace.
* If you use `landmarks` to compare performances of parts within a program run: it seems that the optional wallclock timer is not reset properly between restarts.
