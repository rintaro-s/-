# ライブラリの読み込み
library(ggplot2)
library(dplyr)

# ユーザーからの入力を受け取る
input_value <- readline(prompt = "geoMap.csvの実行時に入力する列名を指定してください: ")

# 入力値の空白を削除
input_value <- gsub(" ", "", input_value)

# データの読み込み
god_data <- read.csv("god.csv", header = TRUE)
geoMap_data <- read.csv("geoMap.csv", header = TRUE)

# 入力された列名が存在するか確認
if (!(input_value %in% colnames(geoMap_data))) {
  cat("指定された列名がgeoMap.csvに存在しません。入力された文字列:",input_value, "\n")
  stop()
}

# データの整形
god_data <- god_data %>% arrange(国.地域)
geoMap_data <- geoMap_data %>% arrange(国.地域)

# データフレームの作成
god_df <- data.frame(国.地域 = god_data$国.地域, ロリ = god_data$ロリ)
geoMap_df <- data.frame(国.地域 = geoMap_data$国.地域, 実行時入力 = geoMap_data[[input_value]])

# 合致する地域の検出
common_areas <- intersect(god_df$国.地域, geoMap_df$国.地域)

# 合致率の計算
total_areas <- nrow(god_df)
matched_areas <- length(common_areas)
match_rate <- (matched_areas / total_areas) * 100

# グラフ作成
ggplot() +
  geom_point(data = geoMap_df, aes(x = 1:nrow(geoMap_df), y = 実行時入力), color = 'blue') +
  geom_point(data = god_df, aes(x = match(国.地域, geoMap_df$国.地域), y = ロリ), color = 'red') +
  labs(title = "地域ごとのデータポイント",
       x = "位置",
       y = "値") +
  theme_minimal()

# 画像として保存
ggsave("geoMap_plot.jpg")

# 合致率の表示
cat("合致率:", match_rate, "%\n")
