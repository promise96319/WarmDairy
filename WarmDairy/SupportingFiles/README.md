# Warm Dairy

### Date 说明
    - Date 处理 均使用 SwiftDate 库
    - 所有存储的数据都使用的是 UTC 格式
    - 启动时，设置当前时区，所有格式化数据及比较均以当前时区来显示或者比较。

### Image 存储说明
    - 文件格式为 前缀 + 图片id
    - 新增时
        - 上传时，保存到tmp目录，返回tmpPath，插入到HTML中
        - 保存时，将tmp 目录中 图片保存到iCloud，并复制到document中，返回ID
        - 将返回的ID保存到日记的 images 字段中。images 格式为 "id1,id2,id3..."
        - 将 HTML中的 src 替换成 前缀+id，保存日记
        - 读取时，解析 images 字段，得到id数组，并遍历查找
            - 首先在本地 tmp 目录中查找，找到返回路径，否则继续
            - 在 document 中查找，找到 copy 到 tmp 中，返回路径
            - 在 iCloud 中查找，找到 copy 到 document 和 tmp 中
            - 最后将日记 HTML 字符串的 img src的 前缀 + id 全部替换成 路径
            - 返回替换后html的日记
        - 更新日记时
            - 如果日记 images 不存在，此时没有图片，直接跳过，否则继续
            - 解析HTML中的img得到id数组，解析日记images id 得到数组，将两者进行比较
                - 如果 HTML 中的id 在 日记images中存在，直接将HTML 相应image路径替换成id
                - 如果 HTML 中的id 在 日记images中不存在，保存图片（如增添日记）
                - 如果 日记imagesid 在HTML中的id 中不存在，则删除那些不存在的图片
            - 操作后保存日记（同增添日记）
    
