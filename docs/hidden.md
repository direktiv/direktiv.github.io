# Title

Text here


## Sub Title

Text here

### Sub Title 2

Text here

!!! note

    This is a note

---

!!! info

    This is a info

---

!!! tip

    This is a tip

---

!!! warning

    This is a tip

---

!!! example

    This is a tip

---

!!! danger

    This is a tip


``` py title="bubble_sort.py"
def bubble_sort(items):
    for i in range(len(items)):
        for j in range(len(items) - 1 - i):
            if items[j] > items[j + 1]:
                items[j], items[j + 1] = items[j + 1], items[j]
```

---

=== "Tab 1"

    Tab1

=== "Tab 2"

    Tab2