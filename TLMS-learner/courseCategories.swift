import SwiftUI
import FirebaseAuth

struct CourseCategoriesView: View {
    @State private var selectedCategories = Set<UUID>()
    @State private var readyToNavigate = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    @State var courseCategories: [CourseCategory] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                TitleLabel(text: "Select Your Goal!")
                    .padding(.top, 10)
            
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(courseCategories) { category in
                        Button(action: {
                            if selectedCategories.contains(category.id) {
                                selectedCategories.remove(category.id)
                            } else {
                                selectedCategories.removeAll()
                                selectedCategories.insert(category.id)
                            }
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill((selectedCategories.contains(category.id) ? Color("color 2") : Color.white))

                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedCategories.contains(category.id) ? Color.clear : Color.black, lineWidth: 1)
                                        )
                                    
                                    if selectedCategories.contains(category.id) {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 10, height: 8)
                                            .foregroundColor(.white)
                                    }
                                }
                                Text(category.name)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedCategories.contains(category.id) ? Color.purple.opacity(0.4) : Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedCategories.contains(category.id) ? Color.clear : Color.black, lineWidth: 1)
                            )
                        }
                    }
                }
                Spacer()
                
                CustomButton(label: "Continue", action: {
                    setTarget()
                    readyToNavigate = true
                })
            }
            .padding()
            .navigationBarBackButtonHidden()
            .onAppear(perform: {
                allTargets()
            })
            .navigationDestination(isPresented: $readyToNavigate) {
          ContentView1()
//                ProgressView1()
            }
        }
        .navigationBarBackButtonHidden()
    }
    func allTargets() {
        FirebaseServices.shared.fetchTargets { fetchedTargets in
            print("Fetched Targets : \(fetchedTargets)")
            var courseCategories: [CourseCategory] = []
            for i in fetchedTargets{
                let newTarget = CourseCategory(name: i)
                courseCategories.append(newTarget)
            }
            self.courseCategories = courseCategories
            
        }
    }
    
    func setTarget(){
        
        guard let currentUser = Auth.auth().currentUser else{
            print("email not found")
            return
        }
        
        var goal:String = "no goal"
        
        for i in courseCategories{
            if selectedCategories.contains(i.id){
                goal = i.name
                break ;
            }
        }
        
        FirebaseServices.shared.addFieldToLearnerDocument(email: currentUser.email!, fieldName: "goal", newData: goal) { success in
            if success {
                print("Field successfully added")
            } else {
                print("Failed to add field")
            }
        }
        
        
        

        
    }
}

struct CourseCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CourseCategoriesView()
    }
}

struct SignupView: View {
    var body: some View {
        Text("Signup View")
            .navigationBarHidden(true)
    }
}

struct HeadingLabel1: View {
    var text: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize))
            .fontWeight(.bold)
    }
}

struct CustomButton1: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}


struct ProgressView1: View {
    var body: some View {
        Text("Progress View")
    }
}
