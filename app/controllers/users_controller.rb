class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_days_ago(1)
    @the_day_before = @today_book.count / @yesterday_book.count.to_f * 100

    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    @the_week_before = @this_week_book.count / @last_week_book.count.to_f * 100
    # 一日ごとの個人の本の個数
    @all_books = @books.six_days_book + [@today_book.count]
  end
  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end
  def search_book
    @user = User.find(params[:user_id])
    @books = @user.books
    
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ?', "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
