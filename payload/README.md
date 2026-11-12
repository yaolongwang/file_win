# payload 来源与许可

本目录使用 [MSYS2](https://www.msys2.org/) 的 UCRT64（x86_64）二进制。`file-real.exe`、`libmagic-1.dll` 和 `magic.mgc` 来自 `mingw-w64-ucrt-x86_64-file`，原始上游为 [file project](https://www.darwinsys.com/file/)。其他 DLL 为其间接依赖；各组件许可证见下表。

| 文件              | 上游                                                   | 许可证            | 许可证文件                                                             |
| ----------------- | ------------------------------------------------------ | ----------------- | ---------------------------------------------------------------------- |
| `file-real.exe`   | file project                                           | 2-clause BSD      | [LICENSES/file-COPYING.txt](LICENSES/file-COPYING.txt)                 |
| `libmagic-1.dll`  | file project                                           | 2-clause BSD      | [LICENSES/file-COPYING.txt](LICENSES/file-COPYING.txt)                 |
| `magic.mgc`       | file project                                           | 2-clause BSD      | [LICENSES/file-COPYING.txt](LICENSES/file-COPYING.txt)                 |
| `libsystre-0.dll` | [libsystre](https://github.com/laurikari/tre)          | 2-clause BSD      | [LICENSES/libsystre-LICENSE.txt](LICENSES/libsystre-LICENSE.txt)       |
| `libtre-5.dll`    | [TRE](https://github.com/laurikari/tre)                | 2-clause BSD      | [LICENSES/tre-LICENSE.txt](LICENSES/tre-LICENSE.txt)                   |
| `libintl-8.dll`   | [GNU gettext](https://www.gnu.org/software/gettext/)   | LGPL-2.1-or-later | [LICENSES/gettext-intl-COPYING.LIB](LICENSES/gettext-intl-COPYING.LIB) |
| `libiconv-2.dll`  | [GNU libiconv](https://www.gnu.org/software/libiconv/) | LGPL-2.1-or-later | [LICENSES/libiconv-COPYING.LIB](LICENSES/libiconv-COPYING.LIB)         |

## DLL 依赖链

```text
file-real.exe
└─ libmagic-1.dll
   └─ libsystre-0.dll
      └─ libtre-5.dll
         └─ libintl-8.dll
            └─ libiconv-2.dll
```
