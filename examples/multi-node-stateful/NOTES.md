## Benchmark 1

### Specs

- bastion:  1 x n1-highcpu-96, 369GB local-ssd
- masters:  3 x n1-standard-1
- data:     4 x custom-32-65536, 2x100GB pd-ssd
- client:   2 x n1-standard-1
- indexing: 2 x n1-highcpu-4

### Race results - pmc track



### Race results - http_logs track
------------------------------------------------------
    _______             __   _____
   / ____(_)___  ____ _/ /  / ___/_________  ________
  / /_  / / __ \/ __ `/ /   \__ \/ ___/ __ \/ ___/ _ \
 / __/ / / / / / /_/ / /   ___/ / /__/ /_/ / /  /  __/
/_/   /_/_/ /_/\__,_/_/   /____/\___/\____/_/   \___/
------------------------------------------------------

|   Lap |                          Metric |         Task |     Value |    Unit |
|------:|--------------------------------:|-------------:|----------:|--------:|
|   All |                   Indexing time |              |    163.53 |     min |
|   All |          Indexing throttle time |              |         0 |     min |
|   All |                      Merge time |              |   94.1882 |     min |
|   All |                    Refresh time |              |   6.59652 |     min |
|   All |                      Flush time |              |   1.53987 |     min |
|   All |             Merge throttle time |              |   53.8659 |     min |
|   All |              Total Young Gen GC |              |     65.06 |       s |
|   All |                Total Old Gen GC |              |         0 |       s |
|   All |                      Store size |              |     21.03 |      GB |
|   All |                   Translog size |              |   14.7447 |      GB |
|   All |          Heap used for segments |              |   100.732 |      MB |
|   All |        Heap used for doc values |              |  0.101257 |      MB |
|   All |             Heap used for terms |              |   87.3274 |      MB |
|   All |             Heap used for norms |              | 0.0345459 |      MB |
|   All |            Heap used for points |              |   5.78273 |      MB |
|   All |     Heap used for stored fields |              |   7.48627 |      MB |
|   All |                   Segment count |              |       566 |         |
|   All |                  Min Throughput | index-append |    253547 |  docs/s |
|   All |               Median Throughput | index-append |    261342 |  docs/s |
|   All |                  Max Throughput | index-append |    273587 |  docs/s |
|   All |         50th percentile latency | index-append |   129.247 |      ms |
|   All |         90th percentile latency | index-append |   176.995 |      ms |
|   All |         99th percentile latency | index-append |   457.662 |      ms |
|   All |       99.9th percentile latency | index-append |   1212.67 |      ms |
|   All |      99.99th percentile latency | index-append |   1508.04 |      ms |
|   All |        100th percentile latency | index-append |   1535.09 |      ms |
|   All |    50th percentile service time | index-append |   129.247 |      ms |
|   All |    90th percentile service time | index-append |   176.995 |      ms |
|   All |    99th percentile service time | index-append |   457.662 |      ms |
|   All |  99.9th percentile service time | index-append |   1212.67 |      ms |
|   All | 99.99th percentile service time | index-append |   1508.04 |      ms |
|   All |   100th percentile service time | index-append |   1535.09 |      ms |
|   All |                      error rate | index-append |         0 |       % |
|   All |                  Min Throughput |      default |         8 |   ops/s |
|   All |               Median Throughput |      default |         8 |   ops/s |
|   All |                  Max Throughput |      default |         8 |   ops/s |
|   All |         50th percentile latency |      default |   87.2264 |      ms |
|   All |         90th percentile latency |      default |   90.8736 |      ms |
|   All |         99th percentile latency |      default |   92.3568 |      ms |
|   All |        100th percentile latency |      default |   92.3897 |      ms |
|   All |    50th percentile service time |      default |   87.1345 |      ms |
|   All |    90th percentile service time |      default |   90.7981 |      ms |
|   All |    99th percentile service time |      default |     92.28 |      ms |
|   All |   100th percentile service time |      default |   92.3133 |      ms |
|   All |                      error rate |      default |         0 |       % |
|   All |                  Min Throughput |         term |     50.05 |   ops/s |
|   All |               Median Throughput |         term |     50.06 |   ops/s |
|   All |                  Max Throughput |         term |     50.06 |   ops/s |
|   All |         50th percentile latency |         term |   7.92038 |      ms |
|   All |         90th percentile latency |         term |   8.49465 |      ms |
|   All |         99th percentile latency |         term |   9.94596 |      ms |
|   All |        100th percentile latency |         term |   10.0765 |      ms |
|   All |    50th percentile service time |         term |   7.84655 |      ms |
|   All |    90th percentile service time |         term |   8.41471 |      ms |
|   All |    99th percentile service time |         term |   9.87602 |      ms |
|   All |   100th percentile service time |         term |   10.0048 |      ms |
|   All |                      error rate |         term |         0 |       % |
|   All |                  Min Throughput |        range |       1.5 |   ops/s |
|   All |               Median Throughput |        range |       1.5 |   ops/s |
|   All |                  Max Throughput |        range |       1.5 |   ops/s |
|   All |         50th percentile latency |        range |   503.486 |      ms |
|   All |         90th percentile latency |        range |   514.459 |      ms |
|   All |         99th percentile latency |        range |   532.896 |      ms |
|   All |        100th percentile latency |        range |   576.623 |      ms |
|   All |    50th percentile service time |        range |   503.275 |      ms |
|   All |    90th percentile service time |        range |    514.23 |      ms |
|   All |    99th percentile service time |        range |   532.679 |      ms |
|   All |   100th percentile service time |        range |   576.406 |      ms |
|   All |                      error rate |        range |         0 |       % |
|   All |                  Min Throughput |   hourly_agg |       0.2 |   ops/s |
|   All |               Median Throughput |   hourly_agg |       0.2 |   ops/s |
|   All |                  Max Throughput |   hourly_agg |       0.2 |   ops/s |
|   All |         50th percentile latency |   hourly_agg |   1985.79 |      ms |
|   All |         90th percentile latency |   hourly_agg |    2021.3 |      ms |
|   All |         99th percentile latency |   hourly_agg |   2055.97 |      ms |
|   All |        100th percentile latency |   hourly_agg |   2057.71 |      ms |
|   All |    50th percentile service time |   hourly_agg |    1982.9 |      ms |
|   All |    90th percentile service time |   hourly_agg |    2018.3 |      ms |
|   All |    99th percentile service time |   hourly_agg |   2053.02 |      ms |
|   All |   100th percentile service time |   hourly_agg |   2054.71 |      ms |
|   All |                      error rate |   hourly_agg |         0 |       % |
|   All |                  Min Throughput |       scroll |     25.04 | pages/s |
|   All |               Median Throughput |       scroll |     25.06 | pages/s |
|   All |                  Max Throughput |       scroll |     25.12 | pages/s |
|   All |         50th percentile latency |       scroll |   516.919 |      ms |
|   All |         90th percentile latency |       scroll |   542.704 |      ms |
|   All |         99th percentile latency |       scroll |   573.744 |      ms |
|   All |        100th percentile latency |       scroll |   574.986 |      ms |
|   All |    50th percentile service time |       scroll |   516.394 |      ms |
|   All |    90th percentile service time |       scroll |    542.19 |      ms |
|   All |    99th percentile service time |       scroll |   573.208 |      ms |
|   All |   100th percentile service time |       scroll |   574.478 |      ms |
|   All |                      error rate |       scroll |         0 |       % |


----------------------------------
[INFO] SUCCESS (took 2553 seconds)
----------------------------------