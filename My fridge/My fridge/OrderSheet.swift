
import SwiftUI
import CloudKit
struct OrderSheet: View {
    @State  var showSheet : Bool = false
    @Environment(\.dismiss) var dismiss
    @State  var Name = ""
    @State  var Addquantity = ""
    @State  var date = Date()
    @State var ingrea : [ ingret ] = []
    var body: some View {
        
        NavigationView{
            ZStack{
                
                
                VStack {
                    
                    
                    Form{
                        
                        Text("Product Name :")
                        TextField("Cheese", text: $Name)
                        
                        
                        Text("Add quantity :")
                        TextField("8", text: $Addquantity )
                        
                        
                        DatePicker(
                            "Expiration Date :",
                            selection: $date,
                            displayedComponents: [.date])
//
                        
                    }
                    .padding(.top, 70)
                    
                    Button("Save") {
                        let components = Calendar.current.dateComponents([.year , .month , .day], from: date)
                        
                        print(date)
                        let year = components.year ?? 0
                        let month = components.month ?? 0
                        let day = components.day ?? 0
                        print(year)
                        print(month)
                        print(day)
                        NotificationManager.instance.scheduleNotification(year: year ,month: month , day : day)
                        addingre ()
                        fetchProfile()
                        dismiss()
                        //new
                        let Addquantity: Int = Int(Addquantity) ?? 0
                        
                    }
                    
                    .padding()
                    .foregroundColor(Color.white)
                  
                            
                    
                        .frame(width: 250,height: 50)
                        .background(Color(red: 0.514, green: 0.647, blue: 0.616))
                                    .cornerRadius(10)
                 
                    
                }
                .scrollContentBackground(.hidden)
                
                
            }.navigationTitle("Add Product")
        }
    }
    //func
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
     
        CKContainer.init(identifier: "iCloud.Maryam.My-fridge").publicCloudDatabase.save(record){
            record, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            let seconds = 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               
                
                fetchProfile()
                
                
            }
        }
        
        
    }
   
}
struct OrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheet()
    }
}
