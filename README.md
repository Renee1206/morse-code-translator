# Morse Code Translator

A Morse Code translator implemented in **x86 Assembly Language** using the **Irvine32 Library**.

本專案使用 x86 Assembly 實作文字轉摩斯密碼（Morse Code）的命令列程式。使用者輸入英文文字後，程式會將英文字母、數字及部分標點符號轉換成對應的 Morse Code，並支援連續進行多次轉換。

## Features

- 將英文字母 `A-Z` / `a-z` 轉換為 Morse Code
- 支援數字 `0-9`
- 支援多種標點符號
- 自動將小寫英文字母轉換為大寫後處理
- 使用 `/` 表示輸入字串中的空格
- 不支援的字元以 `@` 表示
- 完成轉換後可選擇繼續進行下一次翻譯

## Supported Characters

### Alphabet

支援所有英文字母：

```text
A-Z
a-z
```

小寫字母會先轉換為大寫，再進行 Morse Code 查表。

### Numbers

```text
0 1 2 3 4 5 6 7 8 9
```

### Punctuation

程式目前支援：

```text
. , ? ( ) ' ; : " - / $
```

其他未定義的字元會輸出：

```text
@
```

注意：輸入字串中的空格會輸出為 `/`，而輸入的 `/` 字元本身會轉換為 Morse Code `-..-.`。

## Example

### Input

```text
Hello, World.
```

### Output

```text
.... . .-.. .-.. --- --..-- / .-- --- .-. .-.. -.. .-.-.-
```

程式完成轉換後會詢問：

```text
Would you like to proceed another translation (y/n)?
```

輸入 `y` 或 `Y` 可以繼續下一次轉換。

## Program Flow

程式主要流程如下：

```text
User Input
    ↓
Convert lowercase letters to uppercase
    ↓
Read each character
    ↓
Determine character type
    ├── Alphabet
    ├── Number
    ├── Punctuation
    ├── Space
    └── Unsupported Character
    ↓
Look up or select corresponding Morse Code
    ↓
Print Morse Code
```

## Implementation

程式主要分成以下幾個 procedures：

### `lowertoCap`

逐字檢查輸入字串，將 `a-z` 的小寫英文字母轉換成 `A-Z`，其他字元保持不變。

### `MorseTran`

依序讀取輸入字串中的每一個字元，並呼叫 `PrintMorse` 執行 Morse Code 轉換。

### `PrintMorse`

判斷目前字元屬於：

- 英文字母
- 數字
- 標點符號
- 空格
- 不支援字元

英文字母與數字透過查表方式取得對應的 Morse Code；標點符號則透過條件判斷取得對應的 Morse Code。

### `PrintToken`

輸出指定的 Morse Code，並在每個 Morse Code token 後加入空格，使結果更容易閱讀。

## Morse Code Tables

英文字母與數字使用查表方式儲存，例如：

```asm
mA BYTE ".-",0
mB BYTE "-...",0
mC BYTE "-.-.",0
...
mZ BYTE "--..",0
```

並透過 pointer table 取得對應資料：

```asm
alphabetTable DWORD OFFSET mA, OFFSET mB, OFFSET mC, ...
numberTable   DWORD OFFSET m0, OFFSET m1, OFFSET m2, ...
```

程式會透過字元的 ASCII 值計算 table index，以取得對應的 Morse Code。

## Technologies Used

- **x86 Assembly**
- **MASM (Microsoft Macro Assembler)**
- **Irvine32 Library**
- **Irvine32 Macros**

## Project Structure

```text
morse-code-translator/
├── morse_code_translator.asm
└── README.md
```

## Requirements

執行本程式需要具備可編譯 Irvine32 程式的 x86 Assembly 開發環境，例如：

- MASM
- Irvine32 Library
- `Irvine32.inc`
- `Macros.inc`
- `Irvine32.lib`

請先完成 Irvine32 Library 的環境設定，再編譯 `morse_code_translator.asm`。

## Notes

- 本專案目前實作的是 **Text → Morse Code** 的單向轉換。
- 英文字母不區分大小寫。
- 輸入字串中的空格會以 `/` 顯示。
- 未支援的字元會以 `@` 顯示。
- 本程式使用 Irvine32 Library，因此需要在支援 MASM 與 Irvine32 的環境中編譯。
