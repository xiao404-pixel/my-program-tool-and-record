#江惠宇
def main():
    row = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]

    mapping = {}
    for row in row:
        for c in row:
            for i in range(len(row)):
                if i < len(row) - 1:
                    mapping[row[i]] = row[i+1]
                    mapping[row[i].lower()] = row[i+1].lower()
                else:
                    mapping[row[i]] = row[i]
                    mapping[row[i].lower()] = row[i].lower()
    a = input()
    output = "".join(mapping.get(ch, ch) for ch in a)
    print(output)
if __name__ == "__main__":
    main()