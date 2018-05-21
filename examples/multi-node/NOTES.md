
## Benchmark 1

### Specs

- bastion:  1 x n1-highcpu-32, 200GB pd-ssd
- masters:  3 x n1-standard-1
- data:     4 x n1-standard-4, 250GB pd-ssd
- client:   2 x n1-standard-1
- indexing: 2 x n1-highcpu-4

### Race results - pmc track
------------------------------------------------------
    _______             __   _____
   / ____(_)___  ____ _/ /  / ___/_________  ________
  / /_  / / __ \/ __ `/ /   \__ \/ ___/ __ \/ ___/ _ \
 / __/ / / / / / /_/ / /   ___/ / /__/ /_/ / /  /  __/
/_/   /_/_/ /_/\__,_/_/   /____/\___/\____/_/   \___/
------------------------------------------------------

|   Lap |                        Metric |                          Task |      Value |    Unit |
|------:|------------------------------:|------------------------------:|-----------:|--------:|
|   All |                 Indexing time |                               |    63.3573 |     min |
|   All |        Indexing throttle time |                               |          0 |     min |
|   All |                    Merge time |                               |    65.7735 |     min |
|   All |                  Refresh time |                               |    11.1902 |     min |
|   All |                    Flush time |                               |    1.46593 |     min |
|   All |           Merge throttle time |                               |    41.8224 |     min |
|   All |            Total Young Gen GC |                               |     78.392 |       s |
|   All |              Total Old Gen GC |                               |      1.477 |       s |
|   All |                    Store size |                               |    20.4638 |      GB |
|   All |                 Translog size |                               |    2.63426 |      GB |
|   All |        Heap used for segments |                               |    22.9892 |      MB |
|   All |      Heap used for doc values |                               |  0.0557823 |      MB |
|   All |           Heap used for terms |                               |    20.9999 |      MB |
|   All |           Heap used for norms |                               |  0.0405884 |      MB |
|   All |          Heap used for points |                               | 0.00939751 |      MB |
|   All |   Heap used for stored fields |                               |    1.88344 |      MB |
|   All |                 Segment count |                               |        133 |         |
|   All |                Min Throughput |                  index-append |     969.27 |  docs/s |
|   All |             Median Throughput |                  index-append |    1000.67 |  docs/s |
|   All |                Max Throughput |                  index-append |     1016.2 |  docs/s |
|   All |       50th percentile latency |                  index-append |    3756.37 |      ms |
|   All |       90th percentile latency |                  index-append |    4997.46 |      ms |
|   All |       99th percentile latency |                  index-append |     6027.8 |      ms |
|   All |      100th percentile latency |                  index-append |    6798.97 |      ms |
|   All |  50th percentile service time |                  index-append |    3756.37 |      ms |
|   All |  90th percentile service time |                  index-append |    4997.46 |      ms |
|   All |  99th percentile service time |                  index-append |     6027.8 |      ms |
|   All | 100th percentile service time |                  index-append |    6798.97 |      ms |
|   All |                    error rate |                  index-append |          0 |       % |
|   All |                Min Throughput |                       default |      20.02 |   ops/s |
|   All |             Median Throughput |                       default |      20.03 |   ops/s |
|   All |                Max Throughput |                       default |      20.03 |   ops/s |
|   All |       50th percentile latency |                       default |    11.3692 |      ms |
|   All |       90th percentile latency |                       default |    11.9901 |      ms |
|   All |       99th percentile latency |                       default |    13.4544 |      ms |
|   All |      100th percentile latency |                       default |    32.0967 |      ms |
|   All |  50th percentile service time |                       default |    11.2474 |      ms |
|   All |  90th percentile service time |                       default |    11.8732 |      ms |
|   All |  99th percentile service time |                       default |    13.3495 |      ms |
|   All | 100th percentile service time |                       default |    31.9788 |      ms |
|   All |                    error rate |                       default |          0 |       % |
|   All |                Min Throughput |                          term |      20.02 |   ops/s |
|   All |             Median Throughput |                          term |      20.03 |   ops/s |
|   All |                Max Throughput |                          term |      20.03 |   ops/s |
|   All |       50th percentile latency |                          term |    10.0994 |      ms |
|   All |       90th percentile latency |                          term |    10.8028 |      ms |
|   All |       99th percentile latency |                          term |    16.7347 |      ms |
|   All |      100th percentile latency |                          term |    37.7303 |      ms |
|   All |  50th percentile service time |                          term |    9.97871 |      ms |
|   All |  90th percentile service time |                          term |    10.6863 |      ms |
|   All |  99th percentile service time |                          term |    16.5716 |      ms |
|   All | 100th percentile service time |                          term |    37.6139 |      ms |
|   All |                    error rate |                          term |          0 |       % |
|   All |                Min Throughput |                        phrase |      20.02 |   ops/s |
|   All |             Median Throughput |                        phrase |      20.03 |   ops/s |
|   All |                Max Throughput |                        phrase |      20.03 |   ops/s |
|   All |       50th percentile latency |                        phrase |    10.3226 |      ms |
|   All |       90th percentile latency |                        phrase |    11.1873 |      ms |
|   All |       99th percentile latency |                        phrase |    31.1553 |      ms |
|   All |      100th percentile latency |                        phrase |     39.707 |      ms |
|   All |  50th percentile service time |                        phrase |    10.1987 |      ms |
|   All |  90th percentile service time |                        phrase |    11.0798 |      ms |
|   All |  99th percentile service time |                        phrase |    31.0324 |      ms |
|   All | 100th percentile service time |                        phrase |    39.5945 |      ms |
|   All |                    error rate |                        phrase |          0 |       % |
|   All |                Min Throughput | articles_monthly_agg_uncached |      20.02 |   ops/s |
|   All |             Median Throughput | articles_monthly_agg_uncached |      20.02 |   ops/s |
|   All |                Max Throughput | articles_monthly_agg_uncached |      20.03 |   ops/s |
|   All |       50th percentile latency | articles_monthly_agg_uncached |    11.9664 |      ms |
|   All |       90th percentile latency | articles_monthly_agg_uncached |     14.054 |      ms |
|   All |       99th percentile latency | articles_monthly_agg_uncached |    15.5021 |      ms |
|   All |      100th percentile latency | articles_monthly_agg_uncached |    16.3048 |      ms |
|   All |  50th percentile service time | articles_monthly_agg_uncached |    11.8255 |      ms |
|   All |  90th percentile service time | articles_monthly_agg_uncached |    13.9055 |      ms |
|   All |  99th percentile service time | articles_monthly_agg_uncached |    15.3559 |      ms |
|   All | 100th percentile service time | articles_monthly_agg_uncached |     16.145 |      ms |
|   All |                    error rate | articles_monthly_agg_uncached |          0 |       % |
|   All |                Min Throughput |   articles_monthly_agg_cached |      20.03 |   ops/s |
|   All |             Median Throughput |   articles_monthly_agg_cached |      20.03 |   ops/s |
|   All |                Max Throughput |   articles_monthly_agg_cached |      20.04 |   ops/s |
|   All |       50th percentile latency |   articles_monthly_agg_cached |    4.73253 |      ms |
|   All |       90th percentile latency |   articles_monthly_agg_cached |    5.12951 |      ms |
|   All |       99th percentile latency |   articles_monthly_agg_cached |    5.41358 |      ms |
|   All |      100th percentile latency |   articles_monthly_agg_cached |    11.2827 |      ms |
|   All |  50th percentile service time |   articles_monthly_agg_cached |    4.57818 |      ms |
|   All |  90th percentile service time |   articles_monthly_agg_cached |     4.9824 |      ms |
|   All |  99th percentile service time |   articles_monthly_agg_cached |    5.26744 |      ms |
|   All | 100th percentile service time |   articles_monthly_agg_cached |    11.1442 |      ms |
|   All |                    error rate |   articles_monthly_agg_cached |          0 |       % |
|   All |                Min Throughput |                        scroll |      21.62 | pages/s |
|   All |             Median Throughput |                        scroll |      21.76 | pages/s |
|   All |                Max Throughput |                        scroll |      21.82 | pages/s |
|   All |       50th percentile latency |                        scroll |    16031.8 |      ms |
|   All |       90th percentile latency |                        scroll |    21645.6 |      ms |
|   All |       99th percentile latency |                        scroll |    22761.8 |      ms |
|   All |      100th percentile latency |                        scroll |    22874.1 |      ms |
|   All |  50th percentile service time |                        scroll |    1134.07 |      ms |
|   All |  90th percentile service time |                        scroll |    1162.55 |      ms |
|   All |  99th percentile service time |                        scroll |    1340.38 |      ms |
|   All | 100th percentile service time |                        scroll |    1367.25 |      ms |
|   All |                    error rate |                        scroll |          0 |       % |


----------------------------------
[INFO] SUCCESS (took 4116 seconds)
----------------------------------