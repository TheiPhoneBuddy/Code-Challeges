struct PaymentMethod: Decodable {
    let name: String
    let token: String
    var lastFour: String? = nil
    var displayFormattedEmail: String? = nil
    
    init(name:String,token:String) {
        self.name = name
        self.token = token
    }
}
