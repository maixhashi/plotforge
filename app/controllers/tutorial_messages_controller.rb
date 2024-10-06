class TutorialMessagesController < ApplicationController
  before_action :authenticate_user! # ログインユーザーのみチュートリアル表示

  def show
    @current_step = session[:tutorial_step] || 0
    @message = TutorialMessage.all[@current_step] # 現在のメッセージを取得

    @show_arrow_navigation = @message.id == 'click_overview_button'

    if @message.nil?
      # メッセージがない場合はリダイレクト
      redirect_to root_path, notice: 'チュートリアルが終了しました'
    end
  end

  def next
    session[:tutorial_step] = (session[:tutorial_step] || 0) + 1
  
    # メッセージが存在するかチェック
    if session[:tutorial_step] < TutorialMessage.all.size
      current_message = TutorialMessage.all[session[:tutorial_step]]
      # redirect_pathが設定されている場合はそのパスへリダイレクト
      if current_message.redirect_path
        redirect_to current_message.redirect_path
      else
        # リダイレクトパスが設定されていない場合はデフォルトのメッセージページへ
        redirect_to tutorial_message_path
      end
    else
      # チュートリアルが終了した場合の処理
      session[:tutorial_step] = nil # ステップをリセット
      redirect_to root_path, notice: 'チュートリアルが終了しました'
    end
  end
  
end
