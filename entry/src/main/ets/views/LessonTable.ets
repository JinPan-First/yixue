/*
 * this class used to create table view (table_base_view)
 *
 * */
import Logger from '../common/logutils'
import variable from '../common/variable'

@Preview
@Component
export default struct LessonTable {
  @Link week: number
  public weekday = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  public times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
  public pp = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  public class = [1, 2, 3, 4, 5, 6, 7]
  public class_color = [Color.Red, Color.Blue, Color.Yellow, Color.Brown, Color.Green,Color.Orange,Color.Grey]
  public class_id = ['大数据架构与技术', '操作系统', '移动应用软件开发', '计算机网络', '软件工程', '企业会计法律风险管理', '形式与政策5']
  //20*7*n
  public lesson = [
    //week one
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[]],
    //week two
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[]],
    //week three
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[]],
    //week four
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[]],
    //week five
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [],[],[]],
    //week six
    [

    ],
    //week seven
    [
    [{name:'大数据架构与技术',start:3,end:4,classroom:'D1237',teacher:'冯永'}, {name:'计算机网络',start:6,end:7,classroom:'D1439',teacher:'孙天昊'},{name:'操作系统实验',start:8,end:9,classroom:'DS3401',teacher:'none'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1136',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1415',teacher:'张程'}],
    [{name:'移动应用软件开发',start:1,end:2,classroom:'DYC307',teacher:'杨瑞龙'},{name:'计算机网络',start:6,end:7,classroom:'D1346',teacher:'孙天昊'},{name:'操作系统实验',start:8,end:9,classroom:'DS3401',teacher:'none'},{name:'大数据架构与技术',start:10,end:11,classroom:'D1336',teacher:'冯永'}],
    [{name:'操作系统',start:1,end:2,classroom:'D1534',teacher:'张玉芳'},{name:'软件工程',start:3,end:4,classroom:'D1242',teacher:'张程'}],
    [{name:'移动应用软件开发',start:6,end:7,classroom:'DYC307',teacher:'杨瑞龙'}],[],[{name:'软件工程实验',start:6,end:9,classroom:'DS3402',teacher:'王翊'}]]]
  @State Number: String[] = ['0', '1', '2', '3', '4']
  scroller: Scroller = new Scroller()

  aboutToAppear(){
    var Log = new Logger('Table')
    Log.info(`${variable.lessons}`)
    Log.info(`${variable.lessons[this.week-1].length}`)
  }


  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Text('十二月').width('10%')
        ForEach(this.weekday, (item) => {
          Text(item).width('13%')
        })
      }.width('100%').height('9%')

      Divider()
      Scroll(this.scroller) {
        Flex({direction:FlexDirection.Row}) {
          Flex({direction:FlexDirection.Column}) {
            ForEach(this.times, (item) => {
              Row() {
                Text(item.toString())
              }.height(60)
            })
          }.width('5.5%')
          if(variable.lessons[this.week-1][0].length!==0||
          variable.lessons[this.week-1][1].length!==0||
          variable.lessons[this.week-1][2].length!==0||
          variable.lessons[this.week-1][3].length!==0||
          variable.lessons[this.week-1][4].length!==0||
          variable.lessons[this.week-1][5].length!==0||
          variable.lessons[this.week-1][6].length!==0
          )
          {
            ForEach(this.class, (index) => {
              Flex({ direction: FlexDirection.Column }) {
                ForEach(variable.lessons[this.week-1][index], (item) => {
                  Flex({ direction: FlexDirection.Column }) {
                    Text(item.name.toString()).opacity(1)
                    Text(item.teacher.toString()).opacity(1)
                    // Text(item.classroom.toString()).opacity(1)
                  }
                  .height(120)
                  .borderRadius(10)
                  .border({ width: 2 })
                  .width('95%')
                  .position({ y: 60 * (item.start - 1), x: 0 })
                  .backgroundColor(this.class_color[this.class_id.indexOf(item.name.toString())])
                  .opacity(0.5)
                })
              }.width('13.5%')
            })
          }
          else {
            Row(){
              Text('本周无课').fontSize(80).width('100%').fontColor(Color.White)
            }.height('100%').width('100%')
        }

        }.width('100%')
      }.width('100%')
    }.width('100%').height('100%')

  }
}