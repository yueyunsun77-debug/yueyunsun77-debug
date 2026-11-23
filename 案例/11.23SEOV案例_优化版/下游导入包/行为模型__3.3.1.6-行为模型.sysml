package Behaviour_3_3_1_6 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    enum def AutoOperation { temperature; circulation; airflow; distribution; frontDefrost; ac; autoRepeat; noChange; }
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：行为适配/上下文。 */
                    out attribute stopRequested : Boolean;
                    out attribute autoModeActive : Boolean;
                    out attribute operation : AutoOperation;
        }
        decide '是否继续评估';
        decide '自动模式判断';
        decide '用户操作判断';
        merge '合并模式结果';
        action '获取自动温控输入' : F_LF_010 {
            doc /* 功能引用：LF-010。 */

        }
        action '调节座舱温度请求' : F_LF_015 {
            doc /* 功能引用：LF-015。 */

        }
        action '协调自动温控请求' : F_LF_011 {
            doc /* 功能引用：LF-011。 */

        }
        action '更新温度并保持AUTO' : F_LF_009 {
            doc /* 功能引用：LF-009, LF-008, LF-014。 */

        }
        action '保持AUTO循环操作' : F_LF_014 {
            doc /* 功能引用：LF-014。 */

        }
        action '退出AUTO并保留其他自动项' : F_LF_014 {
            doc /* 功能引用：LF-014。 */

        }
        action '切换至前除霜模式' : F_LF_014 {
            doc /* 功能引用：LF-014。 */

        }
        action '处理AC关闭与Close反馈' : F_LF_028 {
            doc /* 功能引用：LF-028。 */
            attribute compressorSpeedRequest : Real = 0.0;
            attribute autoStatus : String = "Close";
            doc /* 风量、温度、送风模式及循环等来源指定项仍自动；Close反馈不等于全部自动调节终止。 */
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '记录重复AUTO语义缺口' {
            doc /* 功能引用：LF-014。 */

        }
        action '保持当前自动控制' : F_LF_014 {
            doc /* 功能引用：LF-014。 */

        }
        action '反馈自动与空调状态' : F_LF_013 {
            doc /* 功能引用：LF-012, LF-013。 */

        }
        first start then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested then '自动模式判断';
        first '自动模式判断' if '获取本周期快照'.autoModeActive then '获取自动温控输入';
        first '自动模式判断' if not '获取本周期快照'.autoModeActive then '合并模式结果';
        first '获取自动温控输入' then '调节座舱温度请求';
        first '调节座舱温度请求' then '协调自动温控请求';
        first '协调自动温控请求' then '用户操作判断';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::temperature then '更新温度并保持AUTO';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::circulation then '保持AUTO循环操作';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::airflow then '退出AUTO并保留其他自动项';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::distribution then '退出AUTO并保留其他自动项';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::frontDefrost then '切换至前除霜模式';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::ac then '处理AC关闭与Close反馈';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::autoRepeat then '记录重复AUTO语义缺口';
        first '用户操作判断' if '获取本周期快照'.operation == AutoOperation::noChange then '保持当前自动控制';
        first '更新温度并保持AUTO' then '合并模式结果';
        first '保持AUTO循环操作' then '合并模式结果';
        first '退出AUTO并保留其他自动项' then '合并模式结果';
        first '切换至前除霜模式' then '合并模式结果';
        first '处理AC关闭与Close反馈' then '合并模式结果';
        first '记录重复AUTO语义缺口' then '合并模式结果';
        first '保持当前自动控制' then '合并模式结果';
        first '合并模式结果' then '反馈自动与空调状态';
        first '反馈自动与空调状态' then '获取本周期快照';
    }
}
