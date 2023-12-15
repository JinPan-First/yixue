import variable from '../common/variable'
import LessonTable from '../views/LessonTable'


@Entry
@Component
struct Lesson {
  //定义全局时间
  private time = new Date()
  @State date_show: string = this.time.getFullYear()
    .toString() + ' 年 ' + (this.time.getMonth() + 1).toString() + ' 月 ' + this.time.getDate().toString() + ' 日'
  //当前选择周
  @State TabIndex: number = 1
  @State currentWeek:number = variable.current_week
  @State lastWeek:number = variable.current_week-1
  @State futureWeek:number = variable.current_week+1
  //实际周
  private actualWeek: number = 3
  private controller: TabsController = new TabsController()

  aboutToAppear() {

  }

  build() {
    Column() {
      Row() {
        Column() {
          Row() {
            Text(this.date_show)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          Row() {
            Text('当前为第')
            Text(this.actualWeek.toString())
            Text('周')
          }
          Row() {
            Text('第')
            Text(this.currentWeek.toString())
            Text('周')
          }
        }
        .width('100%').height('10%')
      }

      Divider()
      Tabs({ barPosition: BarPosition.Start, index: this.TabIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            LessonTable({ week: $lastWeek})
          }.width('100%').height('100%')
        }

        TabContent() {
          Column() {
            LessonTable({ week: $currentWeek})
          }
          .width('100%').height('100%')
        }

        TabContent() {
          Column() {
            LessonTable({ week: $futureWeek})
          }.width('100%').height('100%')
        }
      }
      .vertical(false)
      .barWidth(0)
      .barHeight(0)
      .animationDuration(400)
      .onChange((index: number) => {
        this.TabIndex = index
        variable.current_week = index == 0 ? variable.current_week - 1 : (index == 2 ? variable.current_week + 1 : variable.current_week == 1 ? 2 :variable.current_week);
        this.currentWeek = variable.current_week
        this.lastWeek = variable.current_week == 1 ? 1 : variable.current_week - 1
        this.futureWeek = variable.current_week + 1
        this.TabIndex = this.currentWeek == 1 ? 0 : 1
      })
      .width('100%')
      .height('100%')
    }.width('100%').backgroundColor('#e4f7fd').height('100%')
  }

}