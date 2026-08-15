from flask import Blueprint, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
from app.utils.responses import success_response, error_response
from app.services.otp_service import OTPService
from app.models.farmers import Farmer

auth_bp = Blueprint('auth', __name__)
otp_service = OTPService()

@auth_bp.route('/register/send-otp', methods=['POST'])
def farmer_register_send_otp():
    data = request.get_json() or {}
    mobile = data.get("mobile")

    if not mobile:
        return error_response("Mobile number is required", 400)

    if Farmer.objects(mobile=mobile).first():
        return error_response("Mobile already registered", 409)

    sid = otp_service.send_otp(mobile)
    if sid:
        return success_response({"message": "OTP sent successfully"}, 200)

    return error_response("Failed to send OTP", 500)


@auth_bp.route('/register/verify-otp', methods=['POST'])
def farmer_register_verify_otp():
    data = request.get_json() or {}
    mobile = data.get("mobile")
    otp_code = data.get("otp_code")

    if not mobile or not otp_code:
        return error_response("Mobile number and OTP are required", 400)

    if not otp_service.verify_otp(mobile, otp_code):
        return error_response("Invalid OTP", 401)

    temp_token = create_access_token(
        identity=mobile,
        expires_delta=timedelta(minutes=10)
    )

    return success_response(
        {"message": "OTP verified", "temp_token": temp_token},
        200
    )


@auth_bp.route('/register', methods=['POST'])
@jwt_required()
def farmer_register():
    mobile = get_jwt_identity()

    data = request.get_json() or {}
    required = ["name", "aadhar_number"]

    if not all(data.get(f) for f in required):
        return error_response("Missing required fields", 400)

    if Farmer.objects(mobile=mobile).first():
        return error_response("Mobile already registered", 409)

    farmer = Farmer(
        name=data.get("name"),
        mobile=mobile,
        age=data.get("age"),
        gender=data.get("gender"),
        address=data.get("address"),
        aadhar_number=data.get("aadhar_number"),
        mobile_verified=True
    )
    farmer.save()

    access_token = create_access_token(identity=str(farmer.id), expires_delta=timedelta(hours=24))

    return success_response(
        {"message": "Registration successful", "access_token": access_token},
        201
    )


@auth_bp.route('/login/send-otp', methods=['POST'])
def farmer_login_send_otp():
    data = request.get_json() or {}
    mobile = data.get("mobile")

    if not mobile:
        return error_response("Mobile number is required", 400)

    if not Farmer.objects(mobile=mobile).first():
        return error_response("Farmer not found", 404)

    sid = otp_service.send_otp(mobile)
    if sid:
        return success_response({"message": "OTP sent successfully"}, 200)

    return error_response("Failed to send OTP", 500)


@auth_bp.route('/login/verify-otp', methods=['POST'])
def farmer_login_verify_otp():
    data = request.get_json() or {}
    mobile = data.get("mobile")
    otp_code = data.get("otp_code")

    if not mobile or not otp_code:
        return error_response("Mobile number and OTP are required", 400)

    if not otp_service.verify_otp(mobile, otp_code):
        return error_response("Invalid OTP", 401)

    farmer = Farmer.objects(mobile=mobile).first()
    if not farmer:
        return error_response("Farmer not found", 404)

    access_token = create_access_token(identity=str(farmer.id), expires_delta=timedelta(hours=24))

    return success_response(
        {"message": "Login successful", "access_token": access_token},
        200
    )
