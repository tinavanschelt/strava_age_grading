defmodule StravaAgeGradingWeb.UserController do
  use StravaAgeGradingWeb, :controller

  alias StravaAgeGrading.Users
  alias StravaAgeGrading.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id, "name" => name, "sex" => sex}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, name: name, sex: sex)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    IO.inspect(user_params)

    case Users.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> redirect(to: Routes.race_path(conn, :index, %{"sex" => user_params["sex"]}))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
