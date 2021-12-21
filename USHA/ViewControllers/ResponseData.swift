/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ResponseData : Codable {
	let s_QueCode : String?
	let s_SurveyCode : String?
	let s_surveyName : String?
	let s_AnswerType : String?
	let s_Question : String?
	let n_sequence : String?
	let b_IsMandatory : Bool?
	var answerOption : [AnswerOption]?

	enum CodingKeys: String, CodingKey {

		case s_QueCode = "s_QueCode"
		case s_SurveyCode = "s_SurveyCode"
		case s_surveyName = "s_surveyName"
		case s_AnswerType = "s_AnswerType"
		case s_Question = "s_Question"
		case n_sequence = "n_sequence"
		case b_IsMandatory = "b_IsMandatory"
		case answerOption = "AnswerOption"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		s_QueCode = try values.decodeIfPresent(String.self, forKey: .s_QueCode)
		s_SurveyCode = try values.decodeIfPresent(String.self, forKey: .s_SurveyCode)
		s_surveyName = try values.decodeIfPresent(String.self, forKey: .s_surveyName)
		s_AnswerType = try values.decodeIfPresent(String.self, forKey: .s_AnswerType)
		s_Question = try values.decodeIfPresent(String.self, forKey: .s_Question)
		n_sequence = try values.decodeIfPresent(String.self, forKey: .n_sequence)
		b_IsMandatory = try values.decodeIfPresent(Bool.self, forKey: .b_IsMandatory)
        answerOption = try values.decodeIfPresent([AnswerOption].self, forKey: .answerOption)
	}

}
