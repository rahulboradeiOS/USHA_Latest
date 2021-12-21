/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

*/

import Foundation
struct AnswerOption : Codable {
	let s_Answercode : String?
	let s_AnswerOption : String?
	let n_sequence : String?
    var Useranswer : String = ""

	enum CodingKeys: String, CodingKey {

		case s_Answercode = "s_Answercode"
		case s_AnswerOption = "s_AnswerOption"
		case n_sequence = "n_sequence"
        case Useranswer = "Useranswer"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		s_Answercode = try values.decodeIfPresent(String.self, forKey: .s_Answercode)
		s_AnswerOption = try values.decodeIfPresent(String.self, forKey: .s_AnswerOption)
		n_sequence = try values.decodeIfPresent(String.self, forKey: .n_sequence)
        Useranswer = try values.decodeIfPresent(String.self, forKey: .Useranswer) ?? ""
	}

}
