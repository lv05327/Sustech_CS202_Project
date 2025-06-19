## 📁 项目结构

| 文件/模块 | 功能说明 |
|-----------|----------|
| `Top.v` | 顶层模块，连接 CPU 与外设 |
| `IFetch.v` | 指令获取模块，负责 PC 管理与 ROM 读取 |
| `Decoder.v` | 指令解码模块，提取 rs1, rs2, rd 和立即数 |
| `Controller.v` | 控制器模块，根据 opcode/funct 生成控制信号 |
| `ALU.v` | 运算逻辑单元，支持加减、逻辑运算、比较等 |
| `DataMem.v` | 数据存储器模块，读写内存 |
| `MemOrIO.v` | 统一管理内存与 IO 地址映射、数据通路控制 |
| `ioread.v` | IO 输入读取模块（如 Switch） |
| `leds.v` | LED 控制模块 |
| `light_7seg_controller.v` | 七段数码管控制器 |
| `scan_seg.v` | 数码管扫描逻辑 |
| `seg7_tb.v` | 七段数码管仿真测试 |
| `segs.v` | 七段数码管译码逻辑 |
| `the_trigger.v` | 用于输入同步的触发器模块 |
| `data_parser.v` | 外部数据预处理模块（如 UART 输入） |
| `decoder_test.v` | Decoder 模块的仿真测试文件 |

---

## 🧩 IP Core 模块说明（Vivado 集成）

| IP 核名           | 功能描述 |
|------------------|----------|
| `prgrom`         | 指令存储器 ROM，连接 `IFetch`，用于加载程序 |
| `RAM`            | 数据内存，连接 `DataMem` 与 `MemOrIO`，支持读写 |
| `uart_ips`       | 串口通信模块，支持 UART 程序加载 |
| `clk_wiz_0`      | 时钟管理模块，生成 UART 所需 10MHz 时钟 |
| `blk_mem_gen_0`  | Block RAM 生成器，用于 RAM / ROM 实现 |

---
