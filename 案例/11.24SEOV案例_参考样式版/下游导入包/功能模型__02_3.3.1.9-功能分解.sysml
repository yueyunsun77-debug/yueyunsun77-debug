package Decomp_3_3_1_9 {
    public import SEOV_FunctionActions::*;
    action def '前风窗除霜除雾控制' {
        doc /* 仅表达功能分解；行为顺序、条件、并行与反馈见行为模型中的同名根模型。 */
        action '接收风窗除霜或除雾请求' {
            action '接收风窗除霜除雾请求' : F_LF_016;
        }
        action '配置风窗模式参数' {
            action '调节送风模式' : F_LF_017;
            action '调节送风量' : F_LF_018;
            action '调节空气循环方式' : F_LF_019;
            action '保持座舱温度设定' : F_LF_021;
        }
        action '确定制冷除湿请求' {
            action '调节制冷能力' : F_LF_020;
            action '仲裁热管理能力请求' : F_LF_023;
            action '判定低电量制冷许可' : F_LF_024;
        }
        action '反馈风窗运行信息' {
            action '反馈风窗与空调状态' : F_LF_022;
        }
        action '执行风窗温控请求' {
            action '控制前风窗除霜除雾模式' : F_LF_026;
        }
    }
}
