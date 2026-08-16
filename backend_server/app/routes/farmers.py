from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.utils.responses import success_response, error_response
from app.models.farmers import Farmer

farmers_bp = Blueprint('farmers', __name__)

@farmers_bp.route('/me', methods=['GET'])
@jwt_required()
def get_me():
    farmer_id = get_jwt_identity()
    farmer = Farmer.objects(id=farmer_id).first()

    if not farmer:
        return error_response("Farmer not found", 404)

    return success_response(farmer.to_json(), 200)


@farmers_bp.route('/me', methods=['PUT'])
@jwt_required()
def update_me():
    farmer_id = get_jwt_identity()
    farmer = Farmer.objects(id=farmer_id).first()

    if not farmer:
        return error_response("Farmer not found", 404)

    data = request.get_json() or {}
    
    # Update basic fields
    for field in ['name', 'age', 'gender', 'address']:
        if field in data:
            setattr(farmer, field, data[field])
            
    # Note: For after_registration embedded document, we could expand this logic
    # but basic profile updates are covered here.

    farmer.save()
    return success_response(farmer.to_json(), 200)
