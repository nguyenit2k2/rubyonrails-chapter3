class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user == record
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  def following?
    true
  end

  def followers?
    true
  end

end
