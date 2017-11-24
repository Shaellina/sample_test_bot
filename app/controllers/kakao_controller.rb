require 'msgmaker'
require 'parser'

class KakaoController < ApplicationController
  
  @@keyboard = MsgMaker::Keyboard.new
  @@message = MsgMaker::Message.new
  
  def keyboard
    # keyboard = {
    #   :type => "buttons",
    #   :buttons => ["영화", "고양이", "????"]
    # }
    render json: @@keyboard.getBtnKey(["영화", "고양이", "다른거"])
  end

  def message
    basic_keyboard = @@keyboard.getBtnKey(["1번", "2번", "영화"])
    user_msg = params[:content]
    
    if user_msg == "고양이"
      parse = Parser::Animal.new
      message = @@message.getPicMessage("나만고양이 없어", parse.cat)
    elsif user_msg == "영화"
      parse = Parser::Movie.new
      message = @@message.getMssage(parse.naver) + [" 보세요."]
    else
      @@massage.getMssage("모릅니다")
    end
    
    result = {
      message: message,
      keyboard: basic_keyboard
    }
        
    render json: result
  end
  
  def friend_add
    User.create(user_key: params[:user_key], chat_room: 0)
    render nothing: true
  end
  
  def friend_del
    user = User.find_by(user_key: params[:user_key])
    user.destroy
    render nothing: true
  end
  
  def chat_room
    user = User.find_by(user_key: params[:user_key])
    user.plus
    user.save
    render nothing: true
  end
  
  
end
