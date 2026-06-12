/*
 * 智慧倒車雷達警示系統
 *
 * HC-SR04 超音波感測器
 * 有源式蜂鳴器
 * HW-479 RGB LED 模組
 *
 * 接線：
 *
 * HC-SR04
 * VCC  -> 5V
 * GND  -> GND
 * Trig -> D12
 * Echo -> D13
 *
 * 蜂鳴器
 * + -> D8
 * - -> GND
 *
 * RGB LED
 * R -> D3
 * G -> D5
 * B -> D6
 * GND -> GND
 */

// =========================
// 腳位設定
// =========================

const int trigPin = 12;
const int echoPin = 13;

const int buzzerPin = 8;

const int RED   = 3;
const int GREEN = 5;
const int BLUE  = 6;

float distance;

// =========================
// RGB LED控制
// =========================

void setColor(bool r, bool g, bool b)
{
    digitalWrite(RED, r);
    digitalWrite(GREEN, g);
    digitalWrite(BLUE, b);
}

// =========================
// 單閃（紅燈快閃用）
// =========================

void flashOnce(
    int onTime,
    int offTime,
    bool r,
    bool g,
    bool b)
{
    setColor(r, g, b);
    digitalWrite(buzzerPin, HIGH);

    delay(onTime);

    setColor(LOW, LOW, LOW);
    digitalWrite(buzzerPin, LOW);

    delay(offTime);
}

// =========================
// 雙閃（黃燈、橘燈用）
// =========================

void flashTwice(
    bool r,
    bool g,
    bool b,
    int totalPeriod)
{
    // 第一次閃爍
    setColor(r, g, b);
    digitalWrite(buzzerPin, HIGH);
    delay(80);

    setColor(LOW, LOW, LOW);
    digitalWrite(buzzerPin, LOW);
    delay(80);

    // 第二次閃爍
    setColor(r, g, b);
    digitalWrite(buzzerPin, HIGH);
    delay(80);

    setColor(LOW, LOW, LOW);
    digitalWrite(buzzerPin, LOW);

    delay(totalPeriod - 240);
}

// =========================
// 超音波測距
// 5次量測 + 中位數濾波
// =========================

float getDistance()
{
    float d[5];

    for(int i = 0; i < 5; i++)
    {
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);

        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);

        long duration =
            pulseIn(echoPin, HIGH, 30000);

        if(duration == 0)
        {
            d[i] = 999;
        }
        else
        {
            d[i] =
                duration * 0.0343 / 2.0;
        }

        delay(10);
    }

    // 排序取中位數
    for(int i = 0; i < 4; i++)
    {
        for(int j = i + 1; j < 5; j++)
        {
            if(d[i] > d[j])
            {
                float temp = d[i];
                d[i] = d[j];
                d[j] = temp;
            }
        }
    }

    return d[2];
}

// =========================
// 初始化
// =========================

void setup()
{
    Serial.begin(9600);

    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);

    pinMode(buzzerPin, OUTPUT);

    pinMode(RED, OUTPUT);
    pinMode(GREEN, OUTPUT);
    pinMode(BLUE, OUTPUT);

    digitalWrite(buzzerPin, LOW);
}

// =========================
// 主程式
// =========================

void loop()
{
    distance = getDistance();

    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.println(" cm");

    // =====================
    // 安全區 (>30cm)
    // 綠燈常亮
    // 蜂鳴器兩秒響一次
    // =====================
    if(distance > 30)
    {
        setColor(LOW, HIGH, LOW);

        digitalWrite(buzzerPin, HIGH);

        delay(500);
        
        digitalWrite(buzzerPin, LOW);
        delay(2000);
    }

    // =====================
    // 注意區 (20~30cm)
    // 黃燈雙閃
    // 每秒一次
    // =====================
    else if(distance > 20)
    {
        flashTwice(
            HIGH,
            HIGH,
            LOW,
            1000
        );
    }

    // =====================
    // 警戒區 (10~20cm)
    // 橘黃雙閃
    // 每0.5秒一次
    // =====================
    else if(distance > 10)
    {
        flashTwice(
            HIGH,
            HIGH,
            LOW,
            500
        );
    }

    // =====================
    // 危險區 (5~10cm)
    // 紅燈快閃
    // 每0.3秒一次
    // =====================
    else if(distance > 5)
    {
        flashOnce(
            100,
            200,
            HIGH,
            LOW,
            LOW
        );
    }

    // =====================
    // 極危險區 (<=5cm)
    // =====================
    else
    {
        // 紅燈常亮
        setColor(HIGH, LOW, LOW);

        // 蜂鳴器持續鳴叫
        digitalWrite(buzzerPin, HIGH);

        delay(100);
    }
}