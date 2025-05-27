import { linysSymbol } from '../objects/linysSymbol';

@Component
struct LinysSymbolDisplay {
  @Prop symbol: linysSymbol;
  @Link selected: linysSymbol;
  // Colors
  @Prop colors: ResourceColor = $r('app.color.font_color_title');
  @Prop fontWeight: FontWeight = FontWeight.Normal;

  build() {
    Column({ space: 10 }) {
      // SymbolGlyph($r('sys.symbol.beido'))
      // SymbolGlyph($r('sys.symbol.'.concat(this.symbol.name)))
      //   .fontColor([$r('app.color.font_color_title')])
      Text(this.symbol.char)
        .fontColor($r('app.color.font_color_title'))
        .width(50)
        .height(50)
        .fontWeight(this.fontWeight)
        .fontSize(50)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          this.selected = this.symbol;
        })
    }

  }
}

export default LinysSymbolDisplay;