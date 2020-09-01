import matplotlib.pyplot as plt
import numpy as np
import seaborn
x = np.random.normal(size=1000)
samples = []
first = False
with open('compare_conflicted_timestamp_count_w_unconflicted.csv', 'r') as fh:
    for line in fh.readlines():
        if not first:
            first = True
            continue
        samples.append(float(line.split(',')[5]))
plt.hist(samples, density=False, bins=10)  # `density=False` would make counts
plt.ylabel('Number of Users')
plt.xlabel('Percentage Loss');
plt.suptitle('Histogram of Data Loss From Filtering Collisions')
plt.show()
