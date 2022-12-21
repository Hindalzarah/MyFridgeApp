
import SwiftUI
import CloudKit
import UserNotifications
class NotificationManager{

static let instance = NotificationManager()


func scheduleNotification(year: Int,month: Int , day : Int){
    
    let center = UNUserNotificationCenter.current()
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    center.requestAuthorization(options: options) { (success, error)in
        guard error != nil else { return }
    }
    let content = UNMutableNotificationContent()
    content.title = "Expiration Date°"
    content.subtitle = "mr"
    content.sound = .default
    content.badge = 0
    
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    dateComponents.year = 2019
    dateComponents.month = 8
    dateComponents.day = 8
 
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
}
}
struct MyIngredients: View {
    @State var showSheetView = false
   
@State  var Name = ""
@State  var Addquantity = ""
    
@State  var date = Date()
    @State var ingrea : [ ingret ] = []

    
      var dateFormatter: DateFormatter {
      let formatter = DateFormatter ()
     formatter.dateStyle = .short
  
      return formatter
      }
    
    
var body: some View {
    NavigationView {
        VStack{
            
            List{
                ForEach(ingrea) { ingrea  in
                   
                    VStack(alignment: .leading, spacing:6){
                        HStack{
                            Text("\(ingrea.Name)")
                                .font(.title)
                           
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("\(ingrea.Addquantity)")
                                 
                                    .foregroundColor(Color(red: 0.957, green: 0.518, blue: 0.514, opacity: 1.0))
                                
                                Text( dateFormatter.string(from: ingrea.date))
                                    .foregroundColor(Color(red: 0.514, green: 0.647, blue: 0.616))
                                    
                            }
                        }}
                        .padding(6)
                        
                    
                } .onDelete(perform: delete)
                
            } .listStyle(.plain)
                .refreshable {}
              
               
            
                .onAppear{
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    fetchProfile ()
                    addingre()
                    
                }
            
          
            
            
        }
        .navigationBarTitle(Text("My ingredients"), displayMode: .automatic)
        
        .navigationBarItems(trailing: Button(action:{ self.showSheetView.toggle()
            
        }){
            Image(systemName: "text.badge.plus")}
        )  .sheet(isPresented: $showSheetView) {
            OrderSheet()
        }                       .presentationDetents([.medium])
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.automatic)
        .foregroundStyle(Color.black)
          
        
    }
                    
                                          
    }
     
    func delete(at offsets: IndexSet) {
            ingrea.remove(atOffsets: offsets)
        }
                                          
    
    func fetchProfile(){
        
        ingrea = []
        
        print("In fetchProfile")
        
        
        let predicate = NSPredicate(value: true)
       
        let query = CKQuery(recordType: "ingredient", predicate: predicate)
        
        let operations = CKQueryOperation(query: query)
        
        operations.recordMatchedBlock = {  recordId, result in
            
            switch result {
            case .success( let records):
                let ingrea = ingret(record: records)
                self.ingrea.append(ingrea)
                //
//                self.ingrea = []
                print(self.ingrea.count)
            case .failure( let error):
                print(error.localizedDescription)
            }
            
        }
        
        CKContainer.default().publicCloudDatabase.add(operations)
    }
   
 
    func addingre (){
        let record = CKRecord(recordType: "ingredient")
        record["Name"] = self.Name
        record["Addquantity"] = self.Addquantity
        record["date"] = self.date

        CKContainer.init(identifier: "iCloud.Maryam.test9").publicCloudDatabase.save(record){
            record, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            let seconds = 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                
                
                fetchProfile()
               
               ingrea = []
                
            }
        }
        
        
    }
   
}

struct MyIngredients_Previews: PreviewProvider {
    static var previews: some View {
        MyIngredients()
    }
}
//Model
struct ingret : Identifiable {
    
    let id: CKRecord.ID
    
    let Name : String
    let Addquantity : String
    var date = Date()
    init(record:CKRecord) {
        self.id = record.recordID
        
        self.Name = record["Name"] as? String ?? "N/A"
        self.Addquantity = record["Addquantity"] as? String ?? "5"
      self.date = record["date"] as? Date ?? Date()
    }
    
}

