# arg1 = filepath
# arg2 = lines to skip
# arg3 = col to collect

x <- commandArgs(TRUE);
data <- read.table(x[1], skip = x[2])[, as.numeric(x[3])];
nums <- fivenum(data, na.rm = TRUE);
cat ( nums[2] - IQR(data) * 1.5, nums[4] + IQR(data) * 1.5 );
