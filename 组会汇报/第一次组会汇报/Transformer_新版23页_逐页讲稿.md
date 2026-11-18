# Transformer 第一次组会汇报｜结构重组预览版

本版仅供预览，未上传 GitHub。

主讲第 1—21 页，约 20 分钟；第 22—23 页为附录与参考文献。
结构：背景与已有方法 → 架构原理 → 创新对比与实现 → 实验效果与总结。

全部页面为白底；使用端正的 Noto Sans CJK SC 黑体，统一正体。PDF 保留完整字体显示。
论文：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 01｜封面

今天汇报Transformer的原始论文。我会先介绍论文的研究背景和已有方法，再解释架构与计算原理，随后重点说明与已有方法相比做了哪些改动、怎样实现，以及实验支持哪些收益。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 02｜目录

汇报按四部分展开。背景部分建立研究动机；架构部分解释方法如何计算；创新部分用改动前后对比说明价值；最后用整体结果和模型变体实验检验这些说法。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 03｜研究背景：序列到序列

论文主要研究机器翻译。输入是源语言词元序列，输出是目标语言词元序列，长度可以不同。模型需要理解上下文、处理语序变化并找到源句与目标句的对应关系。这里的英德句子只帮助说明任务，不是作者报告的实验案例。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 04｜此前的方法如何工作

已有循环模型沿位置顺序更新隐藏状态，再用注意力在解码时选择相关源位置。已有卷积模型能并行计算位置特征，但局部卷积需要多层来传递远距离信息。注意力并不是Transformer首次发明的，本文的关键变化是将自注意力放到表示学习的核心，而不是只把它附加在循环或卷积表示之上。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 05｜已有方法的问题

不能把已有方法概括成完全不能捕获长距离信息。更准确的说法是，循环层仍存在沿位置的顺序计算依赖；局部卷积连接远位置时通常需要多层。这些是计算结构上的限制。作者因此希望缩短信息路径、提升并行性，同时保持翻译质量。这里不把表征路径与所有端到端翻译路径混为一谈。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 06｜论文的研究问题

有了前面的背景，论文的问题就很清楚：能否不用循环或卷积作为序列交互骨干，让注意力直接承担这一职责？设计还必须解决多种联系如何共同表示、词序信息从哪里来、解码时如何避免读取未来答案等问题。接下来先按信息流解释模型，再回到创新对比。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 07｜整体架构

先从底部往上看。源词向量加上位置编码后，进入六层编码器，得到Z。目标输入在训练时右移一位，进入六层解码器；每层先做掩码自注意力，再读取编码器输出。交叉注意力中的K和V来自Z。顶端的线性映射和Softmax给出下一词的分布。框内模块重复六次，嵌入和位置编码不跟着重复。图示省略了残差与层归一化，稍后会补充。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 08｜注意力如何计算

在自注意力中，Q、K、V来自同一序列X的不同可学习线性变换。Q乘K转置得到位置之间的匹配分数，除以根号dk，再对每行做Softmax得到权重，最后乘V完成信息汇总。对于一个查询，结果是多个位置Value的加权组合。末行WQ等符号表示不同投影矩阵，并不是将字母Q直接与X相乘。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 09｜三种注意力的区别

编码器的自注意力对整个源句可见。解码器的自注意力使用下三角掩码；因为目标输入已右移，对角线可见也不会泄漏当前待预测的答案。交叉注意力的Query来自解码器，Key和Value来自编码器。训练时可用已知的右移目标并行计算多个位置，但实际推理仍然逐词生成。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 10｜多头注意力的计算过程

每个头有独立的投影矩阵，在自己的表示子空间中计算注意力。各头输出拼接后，再通过输出投影融合。base配置八个头，每个头的键和值维度均为64，所以拼接后回到512维。不是八个头都计算完整的512维，也不是人为指定某个头一定负责语法。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 11｜位置编码如何计算

原始Transformer没有循环或局部卷积来隐式提供顺序，因此在词嵌入上相加位置向量。不同维度使用不同频率的正弦和余弦，pos是位置，i是维度索引。位置向量与词向量维度相同，不是额外拼接一个位置维度。后面创新对比会说明这是一项配套设计，且原文学习式位置嵌入也取得相近效果。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 12｜一个编码层怎样更新表示

一个编码层先用自注意力混合上下文，再通过残差相加和层归一化稳定表示；然后对每个位置应用相同的两层前馈网络，再做残差与归一化。base前馈网络的中间维度为2048。解码器在相应位置再插入交叉注意力子层。这些模块并不都是本文首次提出，价值在于它们在新骨干中的组织方式。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 13｜创新总览

第一层面的核心创新是架构：自注意力替代循环或卷积作为序列交互骨干。第二是注意力的具体设计：缩放点积与多头。第三是位置编码这一配套设计，保证取消循环后仍有顺序信息。表中的单次注意力和未缩放点积是机制比较对象，不能理解为所有旧模型都只有一个头或完全相同。注意力本身、前馈网络、残差和归一化都不是本文首次发明。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 14｜架构创新的前后对比

对比对象是同一序列内部的表示计算。循环层中的远距离信息要逐步传递，而全局自注意力在一层中允许任意两个可见位置直接联系。Table1因此给出顺序操作与最大路径的差异。实现上是批量矩阵乘法，并不是把所有计算成本都消除了。完整Transformer还有投影和前馈计算，标准注意力本身还有n平方相关开销。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 15｜注意力设计怎样改进

缩放方面，作者在独立零均值单位方差的简化假设下指出，点积方差随dk增大，可能使Softmax进入梯度很小的区域，因此除以根号dk。多头方面，模型为多个头学习独立投影，汇总不同子空间的信息。这里解释的是机制动机，不声称论文把每一项设计的收益都完全隔离证明。多头的具体结果会在实验部分展示。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 16｜位置设计的意义与边界

取消循环和局部卷积后，需要显式位置线索。本文采用多频率的正弦余弦向量，与词向量相加。这是一项让新架构完整可用的配套设计，而不是首次提出位置表示这一概念。作者也比较了学习式位置嵌入，开发集效果接近。正余弦可以为未见位置构造编码，但不等于论文证明所有长度上都能可靠外推。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 17｜如何实现完整模型

从实现角度，首先对输入做词嵌入和位置编码，再堆叠编码器。训练目标序列右移一位后进入解码器，下三角掩码保证不能读取未来答案，交叉注意力读取编码器输出。顶层输出词概率，用含标签平滑的交叉熵训练，通过Adam和warm-up学习率计划更新参数。这里列base参数。推理时没有完整目标真值，必须依次使用已生成的词。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 18｜实验设置

论文主实验是WMT2014英德和英法翻译。英德约450万句对，英法约3600万句对，在八张P100上训练。base约12小时，big约3.5天。质量以BLEU衡量，同设置下越高越好，但不是准确率百分比。训练FLOPs来自作者的估算，不能等同于完全控制硬件和实现条件的速度实验。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 19｜整体实验结果支持哪些收益

图中摘选Table2的英德结果。Transformer big为28.4，ConvS2S集成为26.36，差值是2.04 BLEU；前者估算训练FLOPs为23乘10的18次方，后者77乘10的18次方，比值约0.30。base也以更低成本达到27.3。这里支持整体架构有效，不能把全部提升归因于某一个模块，也不能推断所有任务都更好。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 20｜模型变体说明什么

本页使用开发集结果，不能与上一页的测试集BLEU直接混用。八头为25.8，单头24.9，三十二头25.4。改变头数时，每头维度也随之调整，因此不是在完全固定所有变量下单独改变头数。正余弦位置编码25.8，学习式25.7，说明后者也是可行选择，而不是正余弦有显著优势。这些边界是理解创新收益时必须保留的。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 21｜总结

最后回到开头的问题。之前的强模型已经使用注意力，但表示交互主要依赖循环或卷积。本文把自注意力变成架构骨干，配合多头、位置编码、前馈和残差归一化，得到完整Transformer。收益体现在并行结构、信息路径和翻译实验。限制也很清楚：标准全局注意力有平方成本，原始解码器推理仍是自回归。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 22｜附录公式与计算

单头的QKV都是n乘64，分数矩阵是n乘n，乘V后输出n乘64。例子只考察一个查询，缩放后分数一二零，经Softmax得到约0.245、0.665、0.090。按这些权重求和三个Value向量得到约0.335、0.755。交叉注意力的分数矩阵则是目标长度乘源长度。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 23｜参考文献

所有实验数字使用会议版PDF，未混用当前arXiv版本中不同的英法结果。已有方法的比较按原文背景和参考文献概括，不把其他论文作为第二篇汇报对象。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf
