defmodule StravaParkrunImporter.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :strava_id, :integer
      add :access_token, :text
      add :refresh_token, :text

      timestamps()
    end

  end
end
