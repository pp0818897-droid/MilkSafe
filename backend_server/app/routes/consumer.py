from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.utils.responses import success_response, error_response
from app.models.consumer_checks import ConsumerCheck, Result
from app.models.animals import Animal
from app.models.treatments import Treatment
import datetime

consumer_bp = Blueprint('consumer', __name__)

@consumer_bp.route('/check/<animal_id>', methods=['GET'])
def check_milk_safety(animal_id):
    animal = Animal.objects(id=animal_id).first()
    
    if not animal:
        return error_response("Animal not found", 404)

    # Simplified check logic based on active treatments
    active_treatments = Treatment.objects(animal=animal, is_withdrawal_completed=False, status="diagnosed")
    
    is_safe = active_treatments.count() == 0
    message = "Milk is safe for consumption." if is_safe else "Milk is NOT safe due to active medicine withdrawal periods."

    result_data = Result(
        is_safe_milk=is_safe,
        is_safe_meat=is_safe,
        message=message
    )
    
    check = ConsumerCheck(
        farmer_id=animal.farmer,
        animal_id=animal,
        result=result_data
    ).save()

    return success_response({
        "animal_tag": animal.tag_number,
        "is_safe_milk": is_safe,
        "message": message,
        "checked_at": check.checked_at
    }, 200)
