"""
utils.py
=========================
工具函式模組

此模組放置所有共用的小工具函式，
避免重複撰寫相同程式。

目前功能：
- 取得目前日期
- 取得紀錄格式日期
- 計算下次測量日期

未來可加入：
- 分隔線輸出
- 時間格式轉換
- CSV 共用工具
- 文字格式化
"""

from datetime import datetime
from datetime import timedelta


def get_today():
    """
    取得目前日期時間。

    Returns
    -------
    datetime
        datetime 物件
    """

    return datetime.now()


def get_today_string():
    """
    取得紀錄用日期格式。

    格式：
    [YYYY/MM/DD]

    Returns
    -------
    str
    """

    return get_today().strftime("[%Y/%m/%d]")


def get_next_measure_date(days=14):
    """
    計算下一次建議測量日期。

    Parameters
    ----------
    days : int
        間隔天數（預設14天）

    Returns
    -------
    str
        YYYY/MM/DD
    """

    return (
        get_today() +
        timedelta(days=days)
    ).strftime("%Y/%m/%d")