package Behaviour_SC3 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：行为适配/上下文。 */
                    out attribute stopRequested : Boolean;
                    out attribute cabinCoolingRequested : Boolean;
                    out attribute batteryCriteriaDefined : Boolean;
                    out attribute batteryTemperatureHigh : Boolean;
                    out attribute batteryPowerHigh : Boolean;
                    out attribute availableCapacitySufficient : Boolean;
                    out attribute chillerPathAvailable : Boolean;
        }
        decide '是否继续评估';
        decide '电池判据定义判断';
        decide '电池辅助需求判断';
        decide '冷量分配能力判断';
        decide '座舱执行需求判断';
        decide '电池执行需求判断';
        decide 'Chiller流路可用判断';
        fork '并行需求评估';
        merge '合并电池需求路径';
        join '汇合需求评估';
        fork '并行执行冷却';
        merge '合并座舱执行路径';
        merge '合并电池执行路径';
        join '汇合冷却执行';
        merge '合并本周期结果';
        action '获取座舱目标温度' : F_S3_F01 {
            doc /* 功能引用：S3-F01。 */

        }
        action '获取座舱实际温度' : F_S3_F02 {
            doc /* 功能引用：S3-F02。 */

        }
        action '判定座舱制冷需求' : F_S3_F03 {
            doc /* 功能引用：S3-F03。 */

        }
        action '获取电池控制温度' : F_S3_F06_01 {
            doc /* 功能引用：S3-F06-01。 */

        }
        action '获取电池充放电功率' : F_S3_F06_02 {
            doc /* 功能引用：S3-F06-02。 */

        }
        action '计算电池冷量需求' : F_S3_F08 {
            doc /* 功能引用：S3-F08。 */

        }
        action '分配共享制冷能力' : F_S3_F09 {
            doc /* 功能引用：S3-F09。 */

        }
        action '调节座舱制冷能力' : F_S3_F04 {
            doc /* 功能引用：S3-F04。 */

        }
        action '调节座舱送风量' : F_S3_F05 {
            doc /* 功能引用：S3-F05。 */

        }
        action '调节电池Chiller液路换热' : F_S3_F10 {
            doc /* 功能引用：S3-F10。 */

        }
        action '反馈座舱与电池温控状态' : F_S3_F11 {
            doc /* 功能引用：S3-F11。 */

        }
        action '记录电池判据未定义' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录无电池辅助冷却需求' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录能力不足分配策略缺口' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '保持无座舱制冷请求' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '保持无电池冷却请求' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录Chiller流路不可用' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        first start then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested then '并行需求评估';
        first '并行需求评估' then '获取座舱目标温度';
        first '获取座舱目标温度' then '获取座舱实际温度';
        first '获取座舱实际温度' then '判定座舱制冷需求';
        first '判定座舱制冷需求' then '汇合需求评估';
        first '并行需求评估' then '获取电池控制温度';
        first '获取电池控制温度' then '获取电池充放电功率';
        first '获取电池充放电功率' then '电池判据定义判断';
        first '电池判据定义判断' if '获取本周期快照'.batteryCriteriaDefined then '电池辅助需求判断';
        first '电池判据定义判断' if not '获取本周期快照'.batteryCriteriaDefined then '记录电池判据未定义';
        first '电池辅助需求判断' if ('获取本周期快照'.batteryTemperatureHigh or '获取本周期快照'.batteryPowerHigh) then '计算电池冷量需求';
        first '电池辅助需求判断' if not ('获取本周期快照'.batteryTemperatureHigh or '获取本周期快照'.batteryPowerHigh) then '记录无电池辅助冷却需求';
        first '计算电池冷量需求' then '合并电池需求路径';
        first '记录无电池辅助冷却需求' then '合并电池需求路径';
        first '记录电池判据未定义' then '合并电池需求路径';
        first '合并电池需求路径' then '汇合需求评估';
        first '汇合需求评估' then '分配共享制冷能力';
        first '分配共享制冷能力' then '冷量分配能力判断';
        first '冷量分配能力判断' if '获取本周期快照'.availableCapacitySufficient then '并行执行冷却';
        first '冷量分配能力判断' if not '获取本周期快照'.availableCapacitySufficient then '记录能力不足分配策略缺口';
        first '记录能力不足分配策略缺口' then '合并本周期结果';
        first '并行执行冷却' then '座舱执行需求判断';
        first '并行执行冷却' then '电池执行需求判断';
        first '座舱执行需求判断' if '获取本周期快照'.cabinCoolingRequested then '调节座舱制冷能力';
        first '座舱执行需求判断' if not '获取本周期快照'.cabinCoolingRequested then '保持无座舱制冷请求';
        first '调节座舱制冷能力' then '调节座舱送风量';
        first '调节座舱送风量' then '合并座舱执行路径';
        first '保持无座舱制冷请求' then '合并座舱执行路径';
        first '合并座舱执行路径' then '汇合冷却执行';
        first '电池执行需求判断' if '获取本周期快照'.batteryCriteriaDefined and ('获取本周期快照'.batteryTemperatureHigh or '获取本周期快照'.batteryPowerHigh) then 'Chiller流路可用判断';
        first '电池执行需求判断' if not ('获取本周期快照'.batteryCriteriaDefined and ('获取本周期快照'.batteryTemperatureHigh or '获取本周期快照'.batteryPowerHigh)) then '保持无电池冷却请求';
        first 'Chiller流路可用判断' if '获取本周期快照'.chillerPathAvailable then '调节电池Chiller液路换热';
        first 'Chiller流路可用判断' if not '获取本周期快照'.chillerPathAvailable then '记录Chiller流路不可用';
        first '调节电池Chiller液路换热' then '合并电池执行路径';
        first '保持无电池冷却请求' then '合并电池执行路径';
        first '记录Chiller流路不可用' then '合并电池执行路径';
        first '合并电池执行路径' then '汇合冷却执行';
        first '汇合冷却执行' then '合并本周期结果';
        first '合并本周期结果' then '反馈座舱与电池温控状态';
        first '反馈座舱与电池温控状态' then '获取本周期快照';
    }
}
