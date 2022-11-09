from django.contrib.gis import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .forms import UserAdminCreationForm, UserAdminChangeForm
from .models import *


admin.site.register(WorldBorder, admin.OSMGeoAdmin)


User = get_user_model()


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    # The forms to add and change user instances
    form = UserAdminChangeForm
    add_form = UserAdminCreationForm

    list_display = ['email', 'first_name', 'last_name', 'admin']
    list_filter = ['admin']
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Information', {'fields': ('first_name', 'last_name',)}),
        ('Permissions', {'fields': ('admin',)}),
        ('Location', {'fields': ('last_location',)}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password', 'password1')}
         ),
    )
    search_fields = ['email', 'first_name', 'last_name']
    ordering = ['email']
    filter_horizontal = ()