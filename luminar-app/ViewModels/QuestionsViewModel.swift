//
//  QuestionsViewModel.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 03/09/25.
//

import Foundation

class QuestionsViewModel {
    // MARK: - Properties
    
    private let testService: TestService
    
    var onQuestionChange: ((String) -> Void)?
    var onQuizFinished: (() -> Void)?
    var onSubmitResult: ((Result<SubmitTestResponse, NetworkError>) -> Void)?
    var onTestSubmissionSuccess: (() -> Void)?
    
    private let questions: [String] = [
        "É fácil para mim identificar como me sinto e por quê",
        "Sou bom em causar uma boa impressão quando conheço novas pessoas",
        "Gosto de passar o tempo me aprofundando cada vez mais nas coisas que estão acontecendo dentro de mim",
        "Gosto de passar tempo sozinho, processando minhas próprias emoções e reações às coisas",
        "Gosto de aprender novas palavras e/ou idiomas",
        "Gosto de cantar ou tocar um instrumento musical",
        "Eu desenho gráficos e tabelas para me ajudar a pensar",
        "Sou melhor em lembrar rostos do que nomes",
        "Não me importo de sujar as mãos em atividades que envolvam criar, consertar ou construir coisas",
        "Gosto de fazer longas caminhadas na natureza, sozinho ou com meus amigos",
        "Gosto de costurar, esculpir, construir modelos ou outras atividades que envolvam destreza",
        "Eu sei quando uma nota está desafinada",
        "Sempre fui excelente em matemática e ciências na escola",
        "Eu adoro ler",
        "Costumo procurar coisas no dicionário",
        "Gosto de línguas e/ou ciências sociais",
        "Passo muito tempo refletindo sobre minhas próprias reações às coisas",
        "Muitas vezes estou cantarolando uma música ou melodia para mim mesmo na minha cabeça",
        "Muitas vezes penso em questões relacionadas à teologia ou à filosofia",
        "Posso aprender melhor se as coisas forem acompanhadas de gráficos, diagramas ou outras ilustrações técnicas",
        "Sinto-me mais vivo quando estou em contato com a natureza",
        "Gosto de cuidar de jardins e plantas",
        "Outras pessoas frequentemente vêm até mim em busca de apoio ou conselho",
        "Gosto de quebra-cabeças sequenciais como o cubo mágico ou o Sudoku",
        "Eu me interesso por esportes",
        "Gosto de aprender sobre diferentes espécies de plantas e animais",
        "Geralmente sou bom com animais",
        "Lembro-me vividamente de detalhes sobre móveis e decoração de interiores dos cômodos em que estive",
        "Sou bom em mediar disputas ou conflitos entre indivíduos",
        "Perguntas como “Para onde a humanidade está indo?” ou “Por que estamos aqui?” me interessam",
        "Gosto de dançar, praticar esportes ou malhar",
        "Gosto de desafios que exigem pensamento lateral, como xadrez",
        "Muitas vezes penso no significado da vida",
        "Tenho interesse em escrever poesias, citações, histórias ou diários",
        "Gosto de aprender sobre como as várias religiões do mundo tentaram responder às “grandes questões”",
        "Passo muito tempo pensando nas emoções dos outros",
        "Sou bom em detectar desonestidade nos outros",
        "Sou bom em ler mapas e me orientar em lugares desconhecidos",
        "Acho mais fácil resolver problemas quando meu corpo está em movimento",
        "Sou bom com números",
        "Gosto de passar tempo me aprofundando cada vez mais nas coisas que estão acontecendo dentro de mim",
        "Gosto de medir ou categorizar coisas",
        "Música é um dos meus maiores interesses",
        "Continuo refletindo sobre questões profundas sobre a vida e a existência que parecem tolas para os outros",
        "Estou sempre descobrindo novos tipos de música"
    ]
    
    private var currentQuestionIndex = 0
    private var collectedAnswers: [Int] = []
    
    init(testService: TestService = TestService()) {
         self.testService = testService
     }
     
    // MARK: - Public Methods
    
    func startQuiz() {
        currentQuestionIndex = 0
        collectedAnswers = []
        // Dispara o evento para a View mostrar a primeira pergunta.
        onQuestionChange?(questions[currentQuestionIndex])
    }
    
    func answerCurrentQuestion(with answerValue: Int) {
           // Validação simples
           guard answerValue >= 1 && answerValue <= 5 else { return }
           
           collectedAnswers.append(answerValue)
           currentQuestionIndex += 1
           
           // Verifica se o quiz terminou
           if currentQuestionIndex < questions.count {
               // Se não, dispara o evento para mostrar a próxima pergunta.
               onQuestionChange!(questions[currentQuestionIndex])
           } else {
               // Se sim, dispara o evento de finalização.
               onQuizFinished?()
           }
    }
    
    func submitTest() {
           // Cria o payload com dados de exemplo (você deve pegar os dados reais do usuário)
           let payload = SubmitTestRequest(
               respostas: collectedAnswers
           )
           
           // Pede ao serviço para enviar os dados.
           testService.submitTest(payload: payload) { [weak self] result in
               // Repassa o resultado para a View.
               self?.onSubmitResult?(result)
               
               if case .success = result {
                   self?.onTestSubmissionSuccess?()
               }
           }
    }
}
