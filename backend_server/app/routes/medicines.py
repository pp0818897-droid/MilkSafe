from flask import Blueprint
from flask_jwt_extended import jwt_required
from app.utils.responses import success_response
from app.models.authorized_medicine import AuthorizedMedicine

medicines_bp = Blueprint('medicines', __name__)

@medicines_bp.route('/', methods=['GET'])
@jwt_required()
def get_medicines():
    # Returns all authorized medicines for vets to prescribe
    medicines = AuthorizedMedicine.objects(is_active=True)
    
    data = []
    for med in medicines:
        data.append({
            "id": str(med.id),
            "name": med.name,
            "generic_name": med.generic_name,
            "category": med.category,
            "manufacturer": med.manufacturer,
            "dosage": med.dosage,
            "frequency": med.frequency,
            "duration_days": med.duration_days,
            "withdrawal_period_days": med.withdrawal_period_days,
            "instructions": med.instructions
        })

    return success_response(data, 200)
