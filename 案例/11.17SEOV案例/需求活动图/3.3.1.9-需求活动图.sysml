// 11.17修订：动作名称采用V+O；保留原技术信号作为实现信息。细分关系与条件以功能抽取JSON为准。
// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package '需求活动图_3319_前后风窗除霜_除雾' {
    private import ScalarValues::*;
    enum def WindscreenRequestKind { frontDefrost; frontDemist; rearUnspecified; unresolved; }

    doc /*
       需求编号：3.3.1.9 前后风窗除霜/除雾。
       主要设计依据：CCU Component Technical Specification 6.12.1.3（印刷页62–63）及6.12.1.4（印刷页63–64）。
       系统级优先级补充依据：SL29 Subsystem Technical Specification 4.1.3.3（印刷页16–17）。
       建模方式参照已验证的需求层活动图ACT：通过场景包、需求层活动、嵌套action、doc注释及ActionFlowView生成活动视图。
       当前PDF只提供前除霜/前除雾详细逻辑；后风窗控制不由前风窗行为推定。
    */

    package 'REQ_3319_前后风窗除霜_除雾' {
        package '需求层活动' {
            action '需求活动执行流程' {
                in requestKind : WindscreenRequestKind;
                // 分析级请求分类；不是新增CAN信号，分类冲突时保持unresolved。
                action '接收风窗除霜或除雾请求' {
                    doc /*
                       对应设计需求：SL30-LC06-SF01 前除霜控制、SL30-LC06-SF02 前除雾控制。
                       用户通过IVI发起请求，并经CAN发送给CCU。
                    */
                }
                action '识别风窗请求类别' {
                    doc /*
                       前除霜与前除雾按对应设计需求处理。
                       Excel标题同时覆盖后风窗，但当前两份PDF没有给出后风窗除霜/加热的完整控制逻辑，
                       因此不能直接将前风窗控制行为套用于后风窗；后风窗部分需补充设计依据。
                    */
                }
                action '配置风窗模式参数' {
                    doc /*
                       前除霜：风口切换至除霜位置、空气输送功能请求最大风量、切换外循环。
                       前除雾：风口切换至除雾位置、最大风量、切换外循环。
                       外循环开度约90%在PDF中属于待定值。
                    */
                }
                action '确定制冷除湿请求' {
                    doc /*
                       根据环境温度条件确定AC请求及制冷执行能力请求（转速接口）。
                       PDF说明制冷执行功能用于除湿时最低转速约1000 rpm，具体数值需标定。
                       系统级优先级参考SSTS-SL29-LC01-SF03：前除霜优先级高于电池包降温和乘员舱制冷，
                       完整仲裁阈值仍有待确认。
                    */
                }
                action '执行风窗温控请求' {
                    doc /*
                       CCU控制相关空气分配调节、空气输送功能及热量与空气调节服务，落实前除霜或前除雾模式的控制请求。
                       模式内温度、风量、循环以及AUTO/AC/模式按钮的交互应遵循对应PDF设计要求。
                    */
                }
                action '反馈风窗运行信息' {
                    doc /*
                       将前除霜/前除雾状态及相关风量、温度、AC、循环等空调信号反馈给IVI显示。
                       后风窗是否采用独立电加热丝、由哪个控制器驱动以及对应反馈信号，仍需补充确认。
                    */
                }

                action '记录待确认风窗请求' { doc /* 后风窗及未知请求在此保留资料缺口，不执行前风窗配置；不规定实车拒绝或故障策略。 */ }
                decide supportedFrontRequest;
                first start then '接收风窗除霜或除雾请求';
                first '接收风窗除霜或除雾请求' then '识别风窗请求类别';
                first '识别风窗请求类别' then supportedFrontRequest;
                first supportedFrontRequest if requestKind == WindscreenRequestKind::frontDefrost or requestKind == WindscreenRequestKind::frontDemist then '配置风窗模式参数';
                first supportedFrontRequest if requestKind == WindscreenRequestKind::rearUnspecified or requestKind == WindscreenRequestKind::unresolved then '记录待确认风窗请求';
                first '记录待确认风窗请求' then done;
                first '配置风窗模式参数' then '确定制冷除湿请求';
                first '确定制冷除湿请求' then '执行风窗温控请求';
                first '执行风窗温控请求' then '反馈风窗运行信息';
                first '反馈风窗运行信息' then done;
            }
        }
    }

    view 'ACT_3319_前后风窗除霜_除雾'
        : $::StandardViewDefinitions::ActionFlowView {
        expose 'REQ_3319_前后风窗除霜_除雾'::'需求层活动'::'需求活动执行流程';
        render $::Views::asInterconnectionDiagram;
    }
}
