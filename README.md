# rvcc-env-docker
Dockerfile for the RVCC course

# How to use

> Note: If you don't have Docker installed, please install Docker for your operating system first.

Just run the following command, and you're good to go!

```bash
# Note: Please replace "path/to/rvcc" with the actual rvcc path on your computer.
docker run -u root --volume path/to/rvcc:/rvcc --rm -it registry.cn-hangzhou.aliyuncs.com/dailycoding/rvcc
```

After running this, you will enter a terminal environment.

You can simply run

```
cd /rvcc
make
```

to build RVCC.

But before running `make test`, you first need to make the following changes in `test.sh`:

```diff
@ -11,12 +11,12 @@ assert() {
- clang -o tmp tmp.s
- # $RISCV/bin/riscv64-unknown-linux-gnu-gcc -static -o tmp tmp.s
+ # clang -o tmp tmp.s
+ $RISCV/bin/riscv64-unknown-linux-gnu-gcc -static -o tmp tmp.s

- ./tmp
- # $RISCV/bin/qemu-riscv64 -L $RISCV/sysroot ./tmp
+ # ./tmp
+ $RISCV/bin/qemu-riscv64 -L $RISCV/sysroot ./tmp
```

After doing your amazing work, you can simply type `exit` to leave the terminal and the Docker container will be gone without you needing to do any cleanup.