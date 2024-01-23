class FAQItemDTO{

  String question;
  String answer;

  FAQItemDTO(this.question, this.answer);

  static List<FAQItemDTO> generateMockedFAQS(){

    var faq1 = FAQItemDTO("Wie Lable ich?", "Stoppuhr oder Graph");
    var faq2 = FAQItemDTO("Was mache ich wenn blablabla", "IDK man schreib dem support oder so");
    var faq3 = FAQItemDTO("Was mache ich wenn lalalululu", "IDK man schreib dem support oder so");

    List<FAQItemDTO> allFAQs = [];
    allFAQs.add(faq1);
    allFAQs.add(faq2);
    allFAQs.add(faq3);


    return allFAQs;
  }
}