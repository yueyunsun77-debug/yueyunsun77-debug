package P_SC3 {
    public import SEOV_FunctionActions::*;
    action def '座舱空调与Chiller电池液冷场景' {
        doc /* 分解不等于执行顺序；条件、信息、并行、反馈关系见功能关系.json。兼容LF指标引用不重复实例化。 */
        action '获取座舱目标温度' : F_S3_F01;
        action '获取座舱实际温度' : F_S3_F02;
        action '判定座舱制冷需求' : F_S3_F03;
        action '调节座舱制冷能力' : F_S3_F04;
        action '调节座舱送风量' : F_S3_F05;
        action '获取电池温度与功率' : F_S3_F06;
        action '判定电池辅助冷却需求' : F_S3_F07;
        action '计算电池冷却能力需求' : F_S3_F08;
        action '分配座舱与电池制冷能力' : F_S3_F09;
        action '调节电池液路换热量' : F_S3_F10;
        action '反馈座舱与电池冷却状态' : F_S3_F11;
    }
}
