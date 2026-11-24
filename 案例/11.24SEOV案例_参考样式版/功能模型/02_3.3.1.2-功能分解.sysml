package Decomp_3_3_1_2 {
    public import SEOV_FunctionActions::*;
    action def '乘员舱制热控制' {
        doc /* 仅表达功能分解；行为顺序、条件、并行与反馈见行为模型中的同名根模型。 */
        action '检查电加热使能条件' {
            action '判定电加热使能条件' : F_LF_001;
            action '判定整车故障下的加热许可' : F_LF_002;
            action '判定电量约束下的加热许可' : F_LF_003;
        }
        action '控制电加热通断' {
            action '控制电加热通断' : F_LF_004;
        }
        action '保护电加热运行' {
            action '切断过温电加热请求' : F_LF_005;
            action '判定电加热恢复许可' : F_LF_006;
            action '获取电加热温度' : F_LF_027;
        }
        action '反馈电加热运行信息' {
            action '反馈电加热状态' : F_LF_007;
        }
    }
}
