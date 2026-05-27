#江惠宇 A114510313
def main():
    line1 = input().strip()
    line2 = input().strip()

    if not (3 < len(line1) <= 20 and 3 < len(line2) <= 20):
        print("error")
        return
    
    print(len(line1))
    print(len(line2))

    combined = line1 + line2
    reversed_str = combined[::-1]
    print(reversed_str)

if __name__ == "__main__":
    main()