@Entry
@Component
struct WidgetCard {
  /*
   * The title.
   */
  readonly TITLE: string = 'Hello World';

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';

  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  readonly NOW_TIME : Date = new Date()
  readonly START_TIME: Date = new Date(this.NOW_TIME.getFullYear(),this.NOW_TIME.getMonth(),this.NOW_TIME.getDate(),7,45,0)
  readonly START_TIME2: Date = new Date(this.NOW_TIME.getFullYear(),this.NOW_TIME.getMonth(),this.NOW_TIME.getDate(),14,25,0)
  readonly class: any[] = [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'},{name:'操作系统实验',start:8,end:9,classroom:'DS3401',teacher:'none'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'操作系统实验',start:8,end:9,classroom:'DS3401',teacher:'none'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[{name:'软件工程实验',start:6,end:9,classroom:'DS3402',teacher:'王翊'}]]
  build() {
    Row() {
      Column() {
        List(){
          ForEach(this.class[0] ,(item)=>{
            ListItem(){
              Column() {
                Text(item.name)
                Text(item.classroom)
                Text(item.start<=4 ? ((new Date(this.START_TIME.valueOf() + 55 * 60 * 1000 * item.start)).getHours().toString() + ':' + (new Date(this.START_TIME.valueOf() + 55 * 60 * 1000 * item.start)).getMinutes().toString() + '--' +
                (new Date(this.START_TIME.valueOf() + 55 * 60 * 1000 * item.end)).getHours().toString() + ':' + (new Date(this.START_TIME.valueOf() + 55 * 60 * 1000 * item.end)).getMinutes().toString()) :
                  (new Date(this.START_TIME2.valueOf() + 55 * 60 * 1000 * (item.start-6)).getHours().toString() + ':' + (new Date(this.START_TIME2.valueOf() + 55 * 60 * 1000 * (item.start-6))).getMinutes().toString() + '--' +
                  (new Date(this.START_TIME2.valueOf() + 55 * 60 * 1000 * (item.end-6))).getHours().toString() + ':' + (new Date(this.START_TIME2.valueOf() + 55 * 60 * 1000 * (item.end-6))).getMinutes().toString()
                  )
                )
              }
            }.height(80).borderRadius(5).backgroundColor('#e4f7fd').width(this.FULL_WIDTH_PERCENT)
          })
        }.height(this.FULL_HEIGHT_PERCENT).width(this.FULL_WIDTH_PERCENT).borderRadius(5).border({width:1}).divider({strokeWidth:1,color:Color.Gray})
      }
      .width(this.FULL_WIDTH_PERCENT)
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        "action": this.ACTION_TYPE,
        "abilityName": this.ABILITY_NAME,
        "params": {
          "message": this.MESSAGE
        }
      });
    })
  }
}