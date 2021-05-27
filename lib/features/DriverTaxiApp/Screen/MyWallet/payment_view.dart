import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';


class PaymentView extends StatelessWidget {
  
  final PageController pageController;
  final Function(String) onAmountChange;
  final String amountSelected;
  PaymentView({this.pageController, this.onAmountChange, this.amountSelected});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 36,
                  ),
                  onPressed: (){
                    pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                )
              ],
            ),
            Container(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.monetization_on, color: yellowClear, size: 20.0),
                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                hintText: 'Monto de recarga',
                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
              ),
              onChanged: (String value){
                return onAmountChange(value);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      return onAmountChange('5');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2 - 2,
                      height: MediaQuery.of(context).size.width * 0.2 - 2,
                      decoration: BoxDecoration(
                        border: amountSelected == '5' ? Border.all(color: Colors.grey) : Border.all(width: 0),
                        shape: BoxShape.circle,
                        color: amountSelected == '5' ? primaryColor : Colors.white
                      ),
                      child: Center(
                        child: Text('S/ 5'),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      return onAmountChange('10');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2 - 2,
                      height: MediaQuery.of(context).size.width * 0.2 - 2,
                      decoration: BoxDecoration(
                        border: amountSelected == '10' ? Border.all(color: Colors.grey) : Border.all(width: 0),
                        shape: BoxShape.circle,
                        color: amountSelected == '10' ? primaryColor : Colors.white
                      ),
                      child: Center(
                        child: Text('S/ 10'),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      return onAmountChange('15');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2 - 2,
                      height: MediaQuery.of(context).size.width * 0.2 - 2,
                      decoration: BoxDecoration(
                        border: amountSelected == '15' ? Border.all(color: Colors.grey) : Border.all(width: 0),
                        shape: BoxShape.circle,
                        color: amountSelected == '15' ? primaryColor : Colors.white
                      ),
                      child: Center(
                        child: Text('S/ 15'),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      return onAmountChange('20');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2 - 2,
                      height: MediaQuery.of(context).size.width * 0.2 - 2,
                      decoration: BoxDecoration(
                        border: amountSelected == '20' ? Border.all(color: Colors.grey) : Border.all(width: 0),
                        shape: BoxShape.circle,
                        color: amountSelected == '20' ? primaryColor : Colors.white
                      ),
                      child: Center(
                        child: Text('S/ 20'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
              child: MaterialButton(
                onPressed: (){
                  pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Text('Proceder al pago', style: TextStyle(color: Colors.white)),
              )
            ),
          ],
        )
      )
    );
  }
}