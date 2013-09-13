class Question
  attr_accessor :title

  def initialize(title, &block)
    @title = title
    @answers = []

    Builder.new(self).instance_eval(&block)
  end

  class Builder
    def initialize(question)
      @question = question
    end

    def wrong(answer, letter)
      @question.add_answer(false, answer, letter)
    end

    def right(answer, letter)
      @question.add_answer(true, answer, letter)
    end
  end

  class Answer
    attr_accessor :title, :letter

    def initialize(rightness, title, letter)
      @right, @title, @letter = rightness, title, letter
    end

    def right?
      @right
    end

    def wrong?
      !right?
    end
  end

  def add_answer(rightness, title, letter)
    @answers << Answer.new(rightness, title, letter)
  end

  def answer(letter)
    answer = @answers.find{|x| x.letter == letter}
    answer && answer.right? ? "Right!" : "Sorry, wrong"
  end
end

def question(name, &block)
  Question.new(name, &block)
end

q1 = question("Who is the president of Spain?") do
  wrong   "Rubalcaba", :a
  wrong   "Carmen de mairena", :b
  right   "A funny joke", :c
end

p q1.answer :c #=> Right!
