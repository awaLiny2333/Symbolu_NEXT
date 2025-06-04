import { linysSymbol } from '../objects/linysSymbol';

@Component
struct LinysSymbolDisplay {
  @Prop symbol: linysSymbol;
  @Link selected: linysSymbol;
  @Prop fontSize: number = 50;
  // Colors
  @Prop colors: ResourceColor = $r("app.color.accent");
  @StorageProp('symbolFontWeight') symbolFontWeight: number = 200;

  build() {
    Column({ space: 10 }) {
      // SymbolGlyph($r('sys.symbol.beido'))
      SymbolGlyph($r('sys.symbol.'.concat(this.symbol.name)))
        .fontColor([$r("app.color.accent")])
      // Text(this.symbol.char)
      //   .fontColor($r('app.color.font_color_title'))
        .width(this.fontSize)
        .height(this.fontSize)
        .fontWeight(this.symbolFontWeight)
        .fontSize(this.fontSize)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          this.selected = this.symbol;
        })
    }

  }
}

export default LinysSymbolDisplay;