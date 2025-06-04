import LinysCapsuleButton from '../components/LinysCapsuleButton';
import LinysSymbolDisplay from '../components/LinysSymbolDisplay';
import { allSymbols } from '../data/allSymbols';
import { animationDefault } from '../data/animationDefault';
import { linysSymbol } from '../objects/linysSymbol';
import LinysSymbolDataSource from '../objects/SymbolDataSource';
import { ItemRestriction, LengthMetrics, SegmentButton, SegmentButtonOptions, SegmentButtonTextItem } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // Environment
  @StorageLink('tablet_mode') tablet_mode: boolean = false;
  @StorageLink('screen_width') screen_width: number = 0;
  @StorageLink('screen_height') screen_height: number = 0;
  @StorageLink('screen_ratio') screen_ratio: number = 0;
  @StorageLink('space') space: number = 10;
  // UI
  @State inputText: string = "";
  @State symbolTest: Resource = $r('sys.symbol.camera_slash_fill');
  @State selected: linysSymbol = allSymbols[0];
  @State waterFlowWidth: number = 0;
  @State scrollInfoHeight: number = 0;
  @State showMore: boolean = false;
  flexSpace: FlexSpaceOptions = { main: LengthMetrics.vp(this.space), cross: LengthMetrics.vp(this.space) };
  // Data
  data: LinysSymbolDataSource = new LinysSymbolDataSource(allSymbols);
  // Symbols
  @StorageLink('symbolFontWeight') symbolFontWeight: number = 400;

  build() {
    RelativeContainer() {
      WaterFlow() {
        LazyForEach(this.data, (s: linysSymbol) => {
          LinysSymbolDisplay({
            symbol: s,
            selected: this.selected
          })
        }, (s: linysSymbol) => {
          return s.unicode;
        })
      } // Symbols
      .columnsTemplate(this.columnsTemplate())
      .columnsGap(15)
      .rowsGap(15)
      .edgeEffect(EdgeEffect.Spring)
      .borderRadius(20)
      .id('symbols')
      .alignRules(this.tablet_mode ?
        {
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: 'info', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: 'operations', align: HorizontalAlign.Start },
        } :
        {
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: 'operations', align: VerticalAlign.Top },
        })
      .animation(animationDefault())
      .onAreaChange((_o, n) => {
        this.waterFlowWidth = n.width as number;
      })

      Operations({ showMore: this.showMore })
        .width(this.tablet_mode ? (this.showMore ? '40%' : 50) : '100%')
        .height(this.tablet_mode ? undefined : (this.showMore ? '60%' : 30))
        .animation(animationDefault())
        .id('operations')
        .alignRules(this.tablet_mode ?
          {
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End },
          } :
          {
            bottom: { anchor: 'info', align: VerticalAlign.Top }
          })

      InfoCopyBar({ selected: this.selected })
        .id('info')
        .padding({ top: this.space })
        .alignRules(this.tablet_mode ?
          {
            bottom: { anchor: 'search', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: 'operations', align: HorizontalAlign.Start },
          } :
          {
            bottom: { anchor: 'search', align: VerticalAlign.Top }
          })

      Row({ space: this.space }) {
        TextInput({ text: this.inputText })// Search Blank
          .layoutWeight(1)
          .onChange((newText) => {
            this.inputText = newText;
          })
          .onSubmit(() => {
            this.searchFor(this.inputText);
          })
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise'))// Reset Button
          .fontColor([$r("app.color.accent")])
          .fontSize(36)
          .onClick(() => {
            this.inputText = '';
            this.searchFor('');
          })
      } // Search
      .padding({ top: this.space })
      .id('search')
      .alignRules(this.tablet_mode ?
        {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: 'operations', align: HorizontalAlign.Start },
        } :
        {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
    }
    .animation(animationDefault())
    .padding({
      left: 15,
      right: 15,
      top: 5,
      // bottom: 15
    })
    .height('100%')
    .width('100%')
    .onAreaChange((o, n) => {
      this.on_main_area_change(o, n);
    })
  }

  searchFor(key: string) {
    console.log('[Woof]Searching for key: ' + key);
    let searchResult: linysSymbol[] = [];
    for (let index = 0; index < allSymbols.length; index++) {
      const element = allSymbols[index];
      if (element.name.toUpperCase().includes(key.toUpperCase())) {
        searchResult.push(element);
      }
    }
    this.data.setData(searchResult);
  }

  on_main_area_change(_old: Area, n: Area) {
    this.screen_width = n.width as number;
    this.screen_height = n.height as number;
    this.tablet_mode = this.screen_width > 500;
    this.screen_ratio = this.screen_width / this.screen_height;
  }

  columnsTemplate() {
    return "1fr ".repeat(Math.ceil(this.waterFlowWidth / 65));
  }
}

@Component
struct InfoCopyBar {
  // Environment
  @StorageProp('space') space: number = 10;
  // UI
  @Prop selected: linysSymbol;

  build() {
    Scroll() {
      Row({ space: this.space }) {
        LinysCapsuleButton({ text: "No. " + this.selected.id.toString() })
        LinysCapsuleButton({ text: " " + this.selected.char + " ", fontSize: 26 })
        LinysCapsuleButton({ text: this.selected.unicode })
        LinysCapsuleButton({ text: this.selected.name })
      }
    } // Info and Copy buttons
    .borderRadius(20)
    .align(Alignment.TopStart)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}

@Component
struct Operations {
  // Environment
  @StorageLink('tablet_mode') tablet_mode: boolean = false;
  @StorageProp('space') space: number = 10;
  // UI
  @Link showMore: boolean;
  @State colorOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: '󰦜' }, { text: '󰘱' }, { text: '󰘔' },] as ItemRestriction<SegmentButtonTextItem>,
    fontColor: $r('app.color.accent'),
    selectedFontColor: $r('app.color.supplementary'),
    selectedBackgroundColor: $r('app.color.accent'),
    fontSize: 24,
    selectedFontSize: 24,
  })
  @State @Watch('onSymbolRenderingStrategySelect') symbolRenderingStrategySelectedIndices: number[] = [0];
  @State onSymbolRenderingStrategy: number = 0;
  // Symbol
  @StorageLink('symbolFontWeight') symbolFontWeight: number = 200;

  build() {
    Column({ space: this.space }) {
      Text(this.tablet_mode ? (this.showMore ? '󰃙' : '󰃚') : (this.showMore ? '󰃛' : '󰃘'))// Hide / Show button
        .fontColor($r("app.color.accent"))
        .textAlign(this.tablet_mode ? TextAlign.Start : TextAlign.Center)
        .fontSize(40)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .width('100%')
        .onClick(() => {
          this.showMore = !this.showMore;
        })
        .margin(this.tablet_mode ? { left: this.space } : {})

      Scroll() {
        Column({ space: this.space }) {
          Row() {
            Text('󰁙')
              .fontSize(30)
              .fontColor($r("app.color.accent"))
            Slider({
              min: 100,
              max: 900,
              value: this.symbolFontWeight,
              style: SliderStyle.InSet,
              step: 100
            })
              .layoutWeight(1)
              .selectedColor($r('app.color.accent'))
              .blockColor($r('app.color.supplementary'))
              .onChange((value: number) => {
                // console.log(value.toString())
                this.symbolFontWeight = value;
              })
          } // FontWeight slider
          Text(this.fontWeightIndicator())
            .fontSize(20)
            .fontColor($r("app.color.accent"))
            .fontWeight(this.symbolFontWeight)
          Row() // For spacing
          SegmentButton({ options: this.colorOptions, selectedIndexes: this.symbolRenderingStrategySelectedIndices })
          Text(this.symbolRenderingStrategyIndicator())
            .fontSize(20)
            .fontColor($r("app.color.accent"))
        }
        .alignItems(HorizontalAlign.End)
        .visibility(this.showMore ? Visibility.Visible : Visibility.Hidden)
        .animation(animationDefault())
      } // Body
      .align(Alignment.Top)
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)

    } // Operations
    .padding(this.tablet_mode ? { left: this.space } : {})
  }

  fontWeightIndicator() {
    let extra: string | undefined = undefined;
    switch (this.symbolFontWeight) {
      case 100:
        extra = 'Lighter';
        break;
      case 400:
        extra = 'Regular / Normal';
        break;
      case 500:
        extra = 'Medium';
        break;
      case 700:
        extra = 'Bold';
        break;
      case 900:
        extra = 'Bolder';
        break;
    }
    return extra || this.symbolFontWeight.toString();
  }

  onSymbolRenderingStrategySelect() {
    this.onSymbolRenderingStrategy = this.symbolRenderingStrategySelectedIndices[0];
  }

  symbolRenderingStrategyIndicator() {
    let extra: string = 'SINGLE';
    switch (this.onSymbolRenderingStrategy) {
      case 0:
        extra = 'SINGLE';
        break;
      case 1:
        extra = 'MULTIPLE_COLOR';
        break;
      case 2:
        extra = 'MULTIPLE_OPACITY';
        break;
    }
    return extra;
  }
}