import sys

from fontTools.ttLib import TTFont


def print_font_glyphs(font_path):
    try:
        font = TTFont(font_path)
    except Exception as e:
        print(f"无法加载字体文件: {e}")
        return

    cmap = font.getBestCmap()
    if not cmap:
        print("字体中没有找到有效的cmap表")
        return

    result = []

    # print('[')
    i = 0
    for code, name in sorted(cmap.items()):
        char = chr(code)
        result.append('new linysSymbol("' + char + '", "U+' + f"{code:06X}" + '", "' + name + '", ' + str(i) + ')')
        i += 1
        # print(f'new linysSymbol("{char}", "U+{code:04X}", "{name}"), ')
    # print(']')

    font.close()

    return 'import { linysSymbol } from "./linysSymbol";\n\nexport const allSymbols: linysSymbol[] = \n[\n' + ',\n'.join(result) + '\n]'


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Use python font_info.py <font directory>")
        sys.exit(1)

    fpath = sys.argv[1]

    fout = open('allSymbols.ets', 'w', encoding='utf-8')
    fout.write(print_font_glyphs(fpath))
    fout.close()
